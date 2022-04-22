function SumData = sumspace(data,SumElements)
%sum the data
SumData = data./sum(data(:,SumElements),2);
