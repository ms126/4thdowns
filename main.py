import pyreadr
import pandas as pd

result = pyreadr.read_r('field_descriptions.rda')
#print(result.keys())

data = result['field_descriptions']
data = pd.DataFrame(data)
print(data)
