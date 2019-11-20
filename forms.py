from flask_wtf import FlaskForm
from wtforms import StringField, FloatField, SubmitField, SelectField
from flask_wtf.file import FileField, FileRequired, FileAllowed
from wtforms.validators import DataRequired, InputRequired
from os import listdir

forecast_pages = listdir('templates/forecast')
def getChoices():
    choices = [("", 'SR Type')]
    for page in forecast_pages:
        name = page[:-5]
        choices.append((name, name))
    return choices


class PredictForm(FlaskForm):
    DISTRICT = StringField('Department')
    DEPARTMENT = StringField('Department')
    DIVISION = StringField('Division')
    SR_TYPE = StringField('SR Type', validators=[DataRequired()])
    QUEUE = StringField('Queue')
    SLA = FloatField('SLA', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    LATITUDE = FloatField('Latitude', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    LONGITUDE = FloatField('Longitude', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    Channel_Type = StringField('Channel Type')
    weatherflag = FloatField('Weather Flag', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    eventType = StringField('Event Type')
    Nearest_facility = FloatField('Nearest facility', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    disnearestpolst = FloatField('Nearest Police Station', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    polStLessThan2km = FloatField('Police Station less than 2km', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    submit = SubmitField('Predict')

    def getDict(self):
        return {key: value.data for key, value in self.__dict__.items() if
         not key.startswith('_') and not callable(key) and key != 'meta' and key != 'submit' and key != 'csrf_token'}


class PredictFile(FlaskForm):
    file = FileField('Upload a csv file', validators=[FileRequired(), FileAllowed(['csv'], 'CSV only!')])
    # file = FileField('Upload a csv file', validators=[FileRequired()], render_kw={'accept':'.csv'})
    submit = SubmitField('Predict')

    def getDict(self):
        return {key: value.data for key, value in self.__dict__.items() if
         not key.startswith('_') and not callable(key) and key != 'meta' and key != 'submit' and key != 'csrf_token'}


class ForecastForm(FlaskForm):
    page = SelectField('Select Call Type',
                       choices=getChoices(),
                       render_kw={'class': 'ui dropdown',
                                  'onchange': 'this.form.submit()'})


