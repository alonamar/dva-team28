from sklearn.linear_model import LogisticRegression
from sklearn.neural_network import MLPClassifier
from joblib import load
import numpy as np
import pandas as pd
import base64

CLASS = ['very early', 'early', 'late', 'very late']
cols_names = [
    'CASE NUMBER',
    'DISTRICT',
    'DEPARTMENT',  # - cat
    'DIVISION',  # - cat
    'SR_TYPE',  # - cat
    'QUEUE',  # - cat
    'SLA',  # - num
    'LATITUDE',  # - num
    'LONGITUDE',  # - num
    'Channel_Type',  # - cat
    'weatherflag',  # - num
    'eventType',  # - cat
    'Nearest_facility',  # - num
    'disnearestpolst',  # - num
    'polStLessThan2km'  # - num
]

### X_test - json
def getResults(X_test, file=False):
    clf = load('static/model/logRegClf.joblib')
    clf2 = load('static/model/sgdRegClf.joblib')
    scaler = load('static/model/scaler.joblib')
    pca = load('static/model/pca.joblib')
    enc = load('static/model/enc.joblib')

    case_number = ""
    if file:
        data, case_number = clean_data(X_test['file'], cols_names)
    else:
        data = dict2DF(X_test)

    numbers = ['SLA', 'LATITUDE', 'LONGITUDE', 'weatherflag', 'Nearest_facility', 'disnearestpolst', 'polStLessThan2km']
    data[numbers] = data[numbers].astype(dtype='float64')
    catDF = data.select_dtypes(include=['object'])
    numDF = data.select_dtypes(include=['float64'])
    catDF = pd.DataFrame(enc.transform(catDF).toarray())
    data = pd.concat([catDF, numDF], axis=1)
    data = scaler.transform(data)
    data = pca.transform(data)

    prob_res = np.max(clf.predict_proba(data), axis=1)
    class_res = clf.predict(data)
    v = np.vectorize(toClassName)
    class_res = v(class_res)
    num_res = clf2.predict(data)
    result = np.vstack([case_number, prob_res, class_res, num_res]).T
    res = pd.DataFrame(result, columns=["CASE NUMBER", "probability", 'status', 'days'])

    if file:
        csv = res.to_csv(index=False)
        b64 = base64.b64encode(csv.encode())
        payload = b64.decode()
        return "data:text/csv;base64," + payload
    else:
        chance = '%.2f' % (float(res['probability'][0])*100) + "%"
        days = str(int(float(res['days'][0])))
        answer = ["There is a chance of " + chance + " to be " + res['status'][0] + ".", "Days estimation: " + days]
        return answer


def dict2DF(data):
    a = pd.DataFrame(columns=list(data.keys()))
    return a.append(data, ignore_index=True)

def clean_data(file, cols_names):
    data = pd.read_csv(file, usecols=cols_names)
    case_number = data['CASE NUMBER'].copy()
    data = data.drop(columns='CASE NUMBER')
    data = data.dropna(subset=['SLA', 'LATITUDE', 'LONGITUDE'])
    data = data.reset_index(drop=True)
    data = data.fillna('unknown')
    return data, case_number


def toClassName(a):
    return CLASS[int(a)]


