import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.linear_model import LogisticRegression
from sklearn import linear_model
from joblib import dump
import sys
import matplotlib.pyplot as plt
from sklearn.model_selection import validation_curve

from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import confusion_matrix
#from sklearn.metrics import plot_roc_curve
import scikitplot as skplt

cols_names = [
    'DISTRICT',  # - cat
    # 'TRASH QUAD',  # - cat
    # 'RECYCLE QUAD',  # - cat
    # 'TRASH DAY',  # - cat
    # 'HEAVY TRASH.DAY',  # - cat
    # 'RECYCLE DAY',  # - cat
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
    'disnearestpolst',  # - num
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
    print("####################################")
    print(clf)
    print(str(clf.score(X_test, y_test)))
    print("####################################")
    if key=='logReg':
        print(confusion_matrix(y_test, clf.predict(X_test)))
        skplt.metrics.plot_roc_curve(y_test, clf.predict_proba(X_test))
        plt.savefig("roc_curve.png", dpi=300)
        plt.show()
    dump(clf, '../joblib/' + key + 'Clf.joblib')
    return


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


def run():
    files = [sys.argv[1], sys.argv[2], sys.argv[3]]  # "../data/Merged_Houston311_Storm_rec_2019.csv"
    data = clean_data(files, cols_names)
    data = preprocessing_data(data)

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

    clf = {'sgdReg': [linear_model.RidgeCV(alphas=np.logspace(-6, 6, 13))],
                      #   linear_model.SGDRegressor(max_iter=5000, loss='huber'),
                      # linear_model.Lasso(alpha=0.1)],
           'logReg': [#LogisticRegression(solver='lbfgs'),
                        #KNeighborsClassifier(3),
                        # SVC(kernel="linear", C=0.025),
                        # SVC(gamma=2, C=1),
                        # GaussianProcessClassifier(1.0 * RBF(1.0)),
                        #DecisionTreeClassifier(max_depth=5),
                        #RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
                        MLPClassifier(alpha=1, solver='sgd')]}#,
                        #AdaBoostClassifier(),
                        #GaussianNB(),
                        #QuadraticDiscriminantAnalysis(),
                        # linear_model.SGDClassifier(max_iter=5000, loss='huber')]}

    # tuned_parameters =  {
    #                         'hidden_layer_sizes': [(50,50,50), (50,100,50), (100,)],
    #                         'activation': ['tanh', 'relu'],
    #                         'solver': ['sgd'],
    #                         'alpha': [1],
    #                         'learning_rate': ['constant','adaptive'],
    #                     }
    # # tuned_parameters = {'hidden_layer_sizes': [(5,), (10,), (5, 2), (10, 5)]}#,
    #                           # 'solver': ['lbfgs', 'sgd', 'adam'],
    #                           # 'alpha': [1e-3, 1e-2, 1e-1, 1, 10]}
    # param_range = {'range': ['lbfgs', 'sgd', 'adam'], 'param': 'solver', "plot": plt.semilogx}
    # #{'range': [(5,), (10,), (5, 2), (10, 5)], 'param': 'hidden_layer_sizes', "plot": plt.semilogx}
    # #{'range': [1e-3, 1e-2, 1e-1, 1, 10], 'param': 'alpha', "plot": plt.semilogx}
    #
    # X, y = X_train, y_train['logReg']
    # gridClf = GridSearchCV(clf['logReg'][0], tuned_parameters, n_jobs=-1)
    # gridClf.fit(X, y)
    # print(gridClf.best_params_)
    # nnClf = gridClf.best_estimator_

    # myRange = param_range['range']
    # param = param_range['param']
    # train_scores, test_scores = validation_curve(clf['logReg'][0], X, y, param, myRange, n_jobs=-1)
    # title = "Validation Curve"
    # plot_curve(param_range['plot'], train_scores, test_scores, myRange, title, param)

    for k in keys:
        for clf_cl in clf[k]:
            classify(X_train, X_test, y_train[k], y_test[k], clf_cl, k)


if __name__ == '__main__':
    run()
