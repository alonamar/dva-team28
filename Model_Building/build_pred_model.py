import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.linear_model import LogisticRegression
from sklearn import linear_model
from joblib import dump, load
import sys
import matplotlib.pyplot as plt
from sklearn.model_selection import validation_curve

from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import confusion_matrix
import scikitplot as skplt

cols_names = [
    'DISTRICT',
    'DEPARTMENT',  # - cat
    'DIVISION',  # - cat
    'SR_TYPE',  # - cat
    'QUEUE',  # - cat
    'SLA',  # - num
    'OVERDUE',  # - num
    'LATITUDE',  # - num
    'LONGITUDE',  # - num
    'Channel_Type',  # - cat
    'weatherflag',  # - num
    'eventType',  # - cat
    'Nearest_facility',  # - num
    'polStLessThan2km'  # - num
]


# cleaning the data
def clean_data(files, cols_names):
    # data2019 = pd.read_csv("../data/Merged_Houston311_Storm_rec_2019.csv", usecols=cols_names)
    data = []
    for f in files:
        data.append(pd.read_csv(f, usecols=cols_names))
    data = pd.concat(data, ignore_index=True)
    data = data.dropna(subset=['SLA', 'OVERDUE', 'LATITUDE', 'LONGITUDE'])
    data = data.reset_index(drop=True)
    data = data.fillna('unknown')
    return data


# preprocessing
def preprocessing_data(data):
    catDF = data.select_dtypes(include=['object'])
    numDF = data.select_dtypes(include=['float64', 'int64'])
    enc = OneHotEncoder(handle_unknown='ignore')
    enc.fit(catDF)
    catDF = pd.DataFrame(enc.transform(catDF).toarray())
    dump(enc, '../joblib/enc.joblib')
    return pd.concat([catDF, numDF], axis=1)


def to_classification(y):
    tmp = y.copy()
    y[tmp.apply(lambda x: True if x <= -150 else False)] = 0
    y[tmp.apply(lambda x: True if -150 < x <= 0 else False)] = 1
    y[tmp.apply(lambda x: True if 0 < x <= 150 else False)] = 2
    y[tmp.apply(lambda x: True if 150 < x else False)] = 3
    return y


# splitting the data
def split_data(X, y):
    return train_test_split(X, y, test_size=1/7.0, random_state=42)


# Standardize the Data
def standard_data(X_train, X_test):
    scaler = StandardScaler()
    scaler.fit(X_train)
    # Apply transform to both the training set and the test set.
    dump(scaler, '../joblib/scaler.joblib')
    return scaler.transform(X_train), scaler.transform(X_test)


# PCA
def pca_data(X_train, X_test):
    pca = PCA(0.95)
    pca.fit(X_train)
    dump(pca, '../joblib/pca.joblib')
    return pca.transform(X_train), pca.transform(X_test)


#run classifiers
def classify(X_train, X_test, y_train, y_test, clf, key):
    clf.fit(X_train, y_train)
    show_res(clf, X_test, y_test, key)
    return


def show_res(clf, X_test, y_test, key):
    print("####################################")
    print(clf)
    print(str(clf.score(X_test, y_test)))
    print("####################################")
    if key == 'logReg':
        print(confusion_matrix(y_test, clf.predict(X_test)))
        skplt.metrics.plot_roc_curve(y_test, clf.predict_proba(X_test))
        plt.savefig(clf.__module__ + "roc_curve.png", dpi=300)
        plt.show()
    dump(clf, '../joblib/' + clf.__module__ + 'Clf.joblib')

def plot_curve(plot_method, train_scores, test_scores, param_range, title, xlabel, ylim=None):
    train_scores_mean = np.mean(train_scores, axis=1)
    test_scores_mean = np.mean(test_scores, axis=1)

    plt.figure()
    plt.title(title)
    if ylim is not None:
        plt.ylim(*ylim)
    plt.xlabel(xlabel)
    plt.ylabel("Score")
    lw = 2

    plot_method(param_range, train_scores_mean, label="Training score",
                color="darkorange", lw=lw)
    plot_method(param_range, test_scores_mean, label="Cross-validation score",
                color="navy", lw=lw)
    plt.grid(True)
    plt.legend(loc="best")
    fileName = title + "_" + xlabel + ".png"
    plt.savefig(fileName, dpi=300)


def tune_clf(tuned_parameters, X_train, y_train, clf):
    print("####################################")
    print(clf.__module__)
    print("####################################")
    X, y = X_train, y_train
    gridClf = GridSearchCV(clf, tuned_parameters, n_jobs=-1)
    gridClf.fit(X, y)
    print(gridClf.best_params_)
    return gridClf.best_estimator_

'''
this code takes the 3 datasets as input and finds the best clasiffiers
while providing the graphs and results
'''
def run():

    files = [sys.argv[1], sys.argv[2], sys.argv[3]]  # "../data/Merged_Houston311_Storm_rec_2019.csv"
    data = clean_data(files, cols_names)
    data = preprocessing_data(data)

    ### change to tune the classifieres
    tune = False
    val_curve = False

    keys = ['logReg', 'sgdReg']
    X = data.drop(columns='OVERDUE')
    y = {}
    for k in keys:
        y[k] = data['OVERDUE'].copy()
    y['logReg'] = to_classification(y['logReg'])

    X_train, X_test, y_train, y_test = {}, {}, {}, {}
    for k in keys:
        X_train, X_test, y_train[k], y_test[k] = split_data(X, y[k])

    X_train, X_test = standard_data(X_train, X_test)
    X_train, X_test = pca_data(X_train, X_test)

    clf = {'sgdReg': [linear_model.RidgeCV(alphas=(0.001, 1, 1000)),
                      linear_model.SGDRegressor(max_iter=5000, loss='huber', penalty='l1'),
                      linear_model.Lasso(alpha=0.3)],
            'logReg': [LogisticRegression(solver='lbfgs', multi_class='ovr'),
                        KNeighborsClassifier(3),
                        DecisionTreeClassifier(max_depth=5),
                        RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
                        MLPClassifier(alpha=1, solver='sgd'),
                        linear_model.SGDClassifier(max_iter=5000, loss='huber')]}

    tuned_parameters = {'sgdReg':[{'alphas': [(0.1, 1.0, 10.0), (0.01, 10, 100), (0.001, 1, 1000)]},
                                  {'loss': ['squared_loss', 'huber', 'epsilon_insensitive'], 'penalty': ['l1', 'l2']},
                                  {'alpha': [0.3, 0.5, 1]}],
                        'logReg': [#{'C': [0.01, 1, 100], 'solver': ['lbfgs', 'liblinear']},
                            {'n_neighbors': range(3, 50, 5), 'weights': ['uniform', 'distance']},
                            {'max_features': np.linspace(0.1,1,10), 'max_depth': range(5, 50, 12)},
                            {'n_estimators': [10, 50, 100], 'max_depth': [None, 2, 6]},
                            {'solver': ['lbfgs', 'sgd', 'adam'], 'alpha': [1e-3, 1e-2, 1e-1, 1, 10]},
                            {'penalty': ['l1', 'l2'], 'loss': ['hinge', 'modified_huber', 'log']}
                        ]}

    clf = {'sgdReg': [linear_model.RidgeCV(alphas=(0.001, 1, 1000))], 'logReg': [MLPClassifier(alpha=1, solver='sgd')]}

    if tune:
        ## tunning
        tuned_clf = {'sgdReg': [], 'logReg': []}
        for k in keys:
            for tune, clfLog in zip(tuned_parameters[k], clf[k]):
                tuned_clf[k].append(tune_clf(tune, X_train, y_train['logReg'], clfLog))
        for k in keys:
            for clf_cl in tuned_clf[k]:
                show_res(clf_cl, X_test, y_test[k], k)
    else:
        for k in keys:
            for clf_cl in clf[k]:
                classify(X_train, X_test, y_train[k], y_test[k], clf_cl, k)


    if val_curve:
        param_range = [{'range': ['lbfgs', 'sgd', 'adam'], 'param': 'solver', "plot": plt.semilogx},
                      {'range': [1e-3, 1e-2, 1e-1, 1, 10], 'param': 'alpha', "plot": plt.semilogx}]
        nnClf = load('../joblib/sklearn.neural_network.multilayer_perceptronClf.joblib')
        for par_range in param_range:
            myRange = par_range['range']
            param = par_range['param']
            train_scores, test_scores = validation_curve(nnClf, X, y['logReg'], param, myRange, n_jobs=-1)
            title = "Validation Curve"
            plot_curve(par_range['plot'], train_scores, test_scores, myRange, title, param)


if __name__ == '__main__':
    run()
