import pandas as pd
import matplotlib.pyplot as plt
import sys

name = sys.argv[1]
re = pd.read_csv('./'+name)



if len(sys.argv) != 2:
    print("Insufficient arguments")
    sys.exit()


np =pd.DataFrame(index=range(0,26))
np ['thread num'],np['Throughput'] =0,0

for i in re.index[1:]: 
    data = re.iloc[i,0].split(':')
    if i%2 == 1:
        np.iloc[i//2,0] = int(data[1])
    else:
        np.iloc[i//2 -1 ,1] = int(data[1])


plt.plot(np['thread num'][:24],np['Throughput'][:24],'bo-')
plt.title('version'+name.split('-')[0])
plt.xlabel('thread num')
plt.ylabel('Throughput')
plt.ylim([0, int(re.iloc[2,0].split(':')[1])*25])
plt.annotate(re.columns[0], xy=(297,100),xycoords='figure pixels')
plt.annotate(re.columns[1], xy=(288,90),xycoords='figure pixels')
plt.annotate(re.columns[2], xy=(280,80),xycoords='figure pixels')
plt.annotate(re.columns[3], xy=(270,70),xycoords='figure pixels')
plt.savefig(name.split('.')[0]+'.png')