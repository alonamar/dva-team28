from flask_wtf import FlaskForm
from wtforms import StringField, FloatField, SubmitField, SelectField
from flask_wtf.file import FileField, FileRequired, FileAllowed
from wtforms.validators import DataRequired, InputRequired
from os import listdir

forecast_pages = listdir('templates/forecast')


def getPages():
    choices = [("", 'SR Type')]
    for page in forecast_pages:
        name = page[:-5]
        choices.append((name, name))
    return choices


def getChoices(names):
    choices = [("", "")]
    for n in names:
        choices.append((n, n))
    return choices

dist_names = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'unknown']
dep_names = ['311 HelpLine', 'EM Emergency Management', 'External Referral', 'Finance', 'GS General Services',
             'HCD Housing Community Development', 'HFD Houston Fire Department', 'HLT Health',
             'NS Neighborhood Services', 'PM Parking Management', 'PR Parks and Recreation',
             'PWE Public Works Engineering', 'SWM Solid Waste Management']
div_names = ['311 Call Handling', 'Collections', 'Community Improvement', 'Customer Escalation', 'Disaster Recovery',
             'EC Engineering Construction', 'Environmental Health', 'Evacuation', 'FM Facilities and Maintenance',
             'Fire Prevention', 'Forestry', 'General Support Services', 'Graffiti', 'Greenspace Management',
             'Investigations', 'Occupancy', 'PDS Planning Development Services', 'PIO Public Information Office',
             'PU Public Utilities', 'Parking Enforcement', 'Parking Meter Maintenance', 'Recycling',
             'Security Management', 'Street and Drainage', 'Traffic Operations']
sr_names = ['Add A Can', 'Air Pollution', 'Container Problem', 'Drainage', 'Fire Hydrant', 'Flooding',
            'Graffiti Private or Commercial Property', 'Health Code', 'Heavy Trash Violation', 'Junk Motor Vehicle',
            'Minimum Standards', 'Missed Garbage Pickup', 'Missed Heavy Trash Pickup', 'Missed Recycling Pickup',
            'Missed Yard Waste Pickup', 'New Resident Container', 'Nuisance On Property', 'Parking Meter',
            'Parking Violation', 'Pothole', 'Recycling Cart Repair or Replace', 'Recycling Participation NEW',
            'Restoration Due To Utility Work', 'SWM Escalation', 'Sewer Wastewater', 'Storm Debris Collection',
            'Street Condition', 'Street Hazard', 'Traffic General', 'Traffic Markings', 'Traffic Signals',
            'Traffic Signs', 'Trash Dumping or Illegal Dumpsite', 'Tree Removal', 'Tree Trim', 'Water Leak',
            'Water Main Valve', 'Water Service']
queue_names = ['EH_BurPolControlPrev', 'NS_Dispatch', 'No Queue Assigned To User', 'PMM_Parking Meter',
               'PM_ParkingEnforcement', 'PR_FacilitiesMaint', 'PR_Forestry', 'PU_FireHydrant', 'PU_UtilitiesMain',
               'PU_WasteWater', 'PU_Water', 'ROWM_StormSewer', 'ROWM_StreetMain', 'SWM_Collections',
               'SWM_CollectionsNE', 'SWM_CollectionsNW', 'SWM_CollectionsSE', 'SWM_CollectionsSW',
               'SWM_CustomerEscalation', 'SWM_GenSupportServ', 'SWM_Recycling', 'SWM_RecyclingNE', 'SWM_RecyclingNW',
               'SWM_RecyclingSE', 'SWM_RecyclingSW', 'TT_AreaEngineering', 'TT_SignalOperations', 'TT_SignsMarking']
channel_names = ['Face2Face', 'Fax In', 'Mail In', 'SMS In', 'Unknown', 'Voice In', 'WAP', 'WEB', 'e-mail In']
event_names = ['Extreme Cold/Wind Chill', 'Flash Flood', 'Flash Flood Tornado Tropical Storm',
               'Flash Flood Tropical Storm', 'Funnel Cloud', 'Funnel Cloud Flash Flood', 'Hail', 'Hail Flash Flood',
               'Hail Flash Flood Thunderstorm Wind', 'Hail Thunderstorm Wind', 'Hail Thunderstorm Wind Lightning',
               'Heat', 'Heavy Rain Flash Flood', 'Heavy Snow', 'Lightning', 'Lightning Flash Flood',
               'Sleet Extreme Cold/Wind Chill', 'Strong Wind', 'Thunderstorm Wind', 'Thunderstorm Wind Flash Flood',
               'Thunderstorm Wind Tornado', 'Thunderstorm Wind Tornado Hail', 'Tornado',
               'Tornado Thunderstorm Wind Lightning Hail Flash Flood', 'Tropical Storm', 'unknown']

class PredictForm(FlaskForm):
    DISTRICT = SelectField('District', choices=getChoices(dist_names))
    DEPARTMENT = SelectField('Department', choices=getChoices(dep_names))
    DIVISION = SelectField('Division', choices=getChoices(div_names))
    SR_TYPE = SelectField('SR Type', choices=[], validators=[DataRequired()])
    QUEUE = SelectField('Queue', choices=getChoices(queue_names))
    # DISTRICT = StringField('District')
    # DEPARTMENT = StringField('Department')
    # DIVISION = StringField('Division')
    # SR_TYPE = StringField('SR Type', validators=[DataRequired()])
    # QUEUE = StringField('Queue')
    # Channel_Type = StringField('Channel Type')
    # eventType = StringField('Event Type')
    SLA = FloatField('SLA', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    LATITUDE = FloatField('Latitude', validators=[InputRequired()],
                          render_kw={'type':'number', 'step':'any', 'max':'31', 'min':'29'})
    LONGITUDE = FloatField('Longitude', validators=[InputRequired()],
                           render_kw={'type':'number', 'step':'any', 'max':'-94', 'min':'-96'})
    Channel_Type = SelectField('Channel Type', choices=getChoices(channel_names))
    weatherflag = FloatField('Weather Flag', validators=[InputRequired()], render_kw={'type':'number', 'step':'any'})
    eventType = SelectField('Event Type', choices=getChoices(event_names))
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
                       choices=getPages(),
                       render_kw={'class': 'ui dropdown',
                                  'onchange': 'this.form.submit(); getLoader()'})


