function pcaTdata = projIntoPCAclr(data,meanSub,coeffs)
pcaTdata = (clrtransform(data) - meanSub)*(coeffs);