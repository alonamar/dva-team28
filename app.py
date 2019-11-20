from flask import Flask, render_template, redirect, url_for, request
from config import Config
import predict
from forms import PredictForm, PredictFile, ForecastForm

app = Flask(__name__)
app.config.from_object(Config)


@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html')


@app.route('/predictions', methods=['GET', 'POST'])
def predictions():
    predForm = PredictForm()
    fileForm = PredictFile()
    answer = request.args.getlist("answer") or ""
    file_link = request.args.get("file_link") or ""
    if predForm.validate_on_submit():
        answer = predict.getResults(predForm.getDict())
        return redirect(url_for('predictions', predForm=predForm, fileForm=fileForm, answer=answer, file_link=file_link))
    elif fileForm.validate_on_submit():
        file_link = predict.getResults(fileForm.getDict(), file=True)
        return redirect(url_for('predictions', predForm=predForm, fileForm=fileForm, answer=answer, file_link=file_link))
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
    iframe = request.args.get("iframe") or ""
    if foreForm.validate_on_submit():
        page = foreForm['page'].data
        return redirect(url_for('forecast', foreForm=foreForm, iframe='forecast/' + page + '.html'))
    return render_template('forecast.html', foreForm=foreForm, iframe=iframe)


@app.route('/forecast/<page>')
def embed_forecast(page):
    return render_template('forecast/' + page)


if __name__ == '__main__':
    app.run()
