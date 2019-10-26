import pandas as pd
from sklearn.preprocessing import OneHotEncoder
from sklearn.model_selection import train_test_split
from sklearn.svm import LinearSVC
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix, classification_report
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from sklearn.neural_network import MLPClassifier


houses = pd.read_csv("Adult_train.tab", sep='\t', skiprows=[1, 2])

y_train = (houses['y'] == '>50K').astype('int')

x_train = houses.drop(['y'], axis=1)
x_train = x_train.drop(['education'], axis=1)
x_train = x_train.drop(['native-country'], axis=1)


def get_one_hot_repr(data, colname):

    ohe = OneHotEncoder()
    result = ohe.fit_transform(data[colname].values.reshape(-1, 1)).toarray()
    result = pd.DataFrame(result, columns=[colname + str(ohe.categories_[0][i]) for i in range(len(ohe.categories_[0]))])
    return result


def substitute_with_one_hot(data, colnames):
    for colname in colnames:
        one_hot_column = get_one_hot_repr(data, colname)
        one_hot_column.fillna(0)
        data = pd.concat([data, one_hot_column], axis=1)
        del data[colname]
    return data


columns = ['workclass', 'marital-status', 'occupation', 'relationship', 'race', 'sex']
data1 = substitute_with_one_hot(x_train, columns)

data_train, data_test, target_train, target_test = train_test_split(
    data1, y_train, test_size=0.80, random_state=10
)


svc_model = LinearSVC(random_state=0, max_iter=10000)
pred = svc_model.fit(data_train, target_train,).predict(data_test)
print("LinearSVC accuracy : ", accuracy_score(target_test, pred, normalize=True))





neigh = KNeighborsClassifier()
neigh.fit(data_train, target_train)
pred = neigh.predict(data_test)
print("KNeighbors accuracy score : ", accuracy_score(target_test, pred))

mlp = MLPClassifier(hidden_layer_sizes=(50, 70, 100, 1000), max_iter=2000, activation='tanh')
pred = mlp.fit(data_train, target_train).predict(data_test)
print("MLPClassifier matrix : ", confusion_matrix(target_test, pred))
print("MLPClassifier report : ", classification_report(target_test, pred))
