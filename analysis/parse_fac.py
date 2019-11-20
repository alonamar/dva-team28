import numpy as np
import pandas as pd
import geopy.distance as geoDist

DATAFOLDER = "../data/"
dispRecFacilities = pd.DataFrame(pd.read_csv(DATAFOLDER + "Disposal and Recycling Facilities.csv")).to_numpy()


def getDist(a, b):
    return geoDist.distance((a[1],a[2]),b).km


def getNearestFacility(location):
    try:
        loc = list(map(float, location))
    except:
        return np.nan
    if np.isnan(loc[0]):
        return np.nan
    return min(np.apply_along_axis(getDist, 1, dispRecFacilities, location))


data = ["Merged_Houston311_Police_Storm_2017.csv", "Merged_Houston311_Storm_2018.csv",
         "Merged_Houston311_Storm_2019.csv"]

df = []
for d in data:
    dftmp = pd.DataFrame(pd.read_csv(DATAFOLDER + d))# + ,
                            #usecols=['LATITUDE', 'LONGITUDE']))
    # dftmp = dftmp[dftmp.LATITUDE != 'Unknown']
    # dftmp = dftmp.dropna(subset=['LATITUDE'])
    df.append(dftmp)

for d, name in zip(df,data):
    d['Nearest_facility'] = d.apply(lambda row: getNearestFacility([row['LATITUDE'], row['LONGITUDE']]), axis=1)
    out = name.strip(".csv")
    d.to_csv(DATAFOLDER + out + "_fac.csv", index=False)
