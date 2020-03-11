import csv
import numpy as np
from sklearn import svm
from sklearn import metrics

def read_dataset(filename):
    csv_file_object = csv.reader(open(filename, 'r'))
    # header = next(csv_file_object)
    x = []
    y = []
    for row in csv_file_object:
        x.append(row[:2])
        y.append(row[2])
    return (np.array(x), np.array(y))

# トレーニングデータ読み込み
X, Y = read_dataset("train.csv")
# テストデータ読み込み
X_, Y_ = read_dataset("test.csv")



# 学習
for kernel in ('linear', 'poly', 'rbf'):

    # SVMでの学習
    clf = svm.SVC(kernel=kernel,C=1, gamma=0.0025)
    clf.fit(X, Y)

    # 正答率
    score = metrics.accuracy_score(clf.predict(X), Y)
    print(kernel,str(score*100)+"%")
