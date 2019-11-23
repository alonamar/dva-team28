from flask import Flask, render_template, redirect, url_for, request, session
from config import Config
import predict
from forms import PredictForm, PredictFile, ForecastForm, getChoices, sr_names
from werkzeug.datastructures import MultiDict

app = Flask(__name__)
app.config.from_object(Config)


@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html')


@app.route('/predictions', methods=['GET', 'POST'])
def predictions():
    predForm = PredictForm()
    predForm['SR_TYPE'].choices = getChoices(sr_names)
    fileForm = PredictFile()

    if request.method == 'GET':
        formdata = session.get('formdata', None)
        predForm = PredictForm(MultiDict(formdata))
        predForm['SR_TYPE'].choices = getChoices(sr_names)
        if formdata is not None:
            session.pop('formdata')

    if predForm.validate_on_submit():
        session['answer'] = predict.getResults(predForm.getDict())
        session['formdata'] = request.form
        return redirect(url_for('predictions'))
    elif fileForm.validate_on_submit():
        session['file_link'] = predict.getResults(fileForm.getDict(), file=True)
        return redirect(url_for('predictions'))

    answer = session.get("answer") or ""
    file_link = session.get("file_link") or ""
    if answer != "": session.pop('answer')
    if file_link != "": session.pop('file_link')
    return render_template('predictions.html', predForm=predForm, fileForm=fileForm, answer=answer, file_link=file_link)


@app.route('/exploratory')
def exploratory():
    return render_template('exploratory.html')


@app.route('/trends')
def trends():
    return render_template('trends.html')


@app.route('/forecast', methods=['GET', 'POST'])
def forecast():
    foreForm = ForecastForm()

    if request.method == 'GET':
        foredata = session.get('foredata', None)
        foreForm = ForecastForm(MultiDict(foredata))
        if foredata is not None:
            session.pop('foredata')

    if foreForm.validate_on_submit():
        page = foreForm['page'].data
        session['foredata'] = request.form
        session['iframe'] = 'forecast/' + page + '.html'
        return redirect(url_for('forecast'))

    iframe = session.get("iframe") or ""
    if iframe != "": session.pop('iframe')
    return render_template('forecast.html', foreForm=foreForm, iframe=iframe)


@app.route('/forecast/<page>')
def embed_forecast(page):
    return render_template('forecast/' + page)


if __name__ == '__main__':
    app.run()
