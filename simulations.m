% manually import monthly sheet in 'CMEupdated.xls', name it Capitalmarketsengine4S1 (done by default)
table = CMEupdatedS1(:, [1:3 13:14 16:17 19 21 42:43 45 52]); 

 
% INFLATION BEGIN–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
% historical data
InflationHistorical = table.USInflationPriceReturn(9:1143);
% open table to house projections (for rates, not growth)
Inflation_rate_projections = zeros(20, 10000);
% in order to temporarily hold 12 moth
rolling = zeros(1124, 1);
rolling2 = zeros(1112, 1);
% we take the log of inflation since inflation is approximately lognormal
logconv = zeros(12, 1);
% calculate 12 month rolling returns
for a = 1:1124
    for b = 1:12
        logconv(b) = log(1+InflationHistorical(a + b-1)/100);
    end
    rolling(a) = sum(logconv);
    if (a>12)
        rolling2(a-12) = rolling(a);
    end
end
% calculate statistics of multiple linear regression
[regs,bint,r,rint,stats] = regress(rolling(1:1112), [ones(1112,1) rolling2(1:1112)]);
Rsq =  stats(1);
beta = regs(2);
% calculate standard deviation
sd = std(rolling);
% 10,000 20 year projections. log(1.02) since we deem 2% the "normal" inflation rate.
for d = 1:10000
    for c = 1:20
        if c == 1
            Inflation_rate_projections(c,d) =  beta*rolling(1124) + (1-beta)*log(1.02) + (1-Rsq)*sd*normrnd(0,1);
        else
            Inflation_rate_projections(c,d) = beta*Inflation_rate_projections(c-1,d) + (1-beta)*log(1.02) + (1-Rsq)*sd*normrnd(0,1);
        end
    end
end
% convert back from log scale
Inflation_rate_projections = (exp(Inflation_rate_projections) - 1);
% growth of $1 to track progression
inflation_growthofdollar = zeros(21, 10000);
% start in 2020 with $1
inflation_growthofdollar(1,:) = 1;
for e = 1:10000
    for f = 2:21
        inflation_growthofdollar(f,e) = inflation_growthofdollar(f-1, e) * (1+Inflation_rate_projections(f-1, e));
    end
end
clearvars a b c d e f R Rsq sd beta bint r rint stats;
% INFLATION END–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––



% ITGvtYld_Historical BEGIN–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
ITGvtYld_Historical = table.USITGvtYldYield(9:1143);
ITGvtYld_projections = zeros(20,10000);
% percent to decimal
ITGvtYld_Historical = ITGvtYld_Historical/100;
% set up for multiple linear regression
y = ITGvtYld_Historical(24:1135);
X = ITGvtYld_Historical(12:1123);
z = rolling2(1:1112)-rolling(1:1112);
[regs,bint,r,rint,stats] = regress(y, [ones(1112,1) X  z]);
sd = std(y);
% projections
for a = 1:10000
    for b = 1:20
        if b == 1
            ITGvtYld_projections(b, a) = regs(2)*ITGvtYld_Historical(1135) + (1-regs(2))*(0.035) + regs(3)*(Inflation_rate_projections(b,a)-InflationHistorical(1135)) + (1-stats(1))*sd*normrnd(0,1);
        else
            ITGvtYld_projections(b,a) = regs(2)*ITGvtYld_projections(b-1,a) + (1-regs(2))*(0.035) + regs(3)*(Inflation_rate_projections(b,a)-Inflation_rate_projections(b-1, a)) + (1-stats(1))*sd*normrnd(0,1);
        end
    end
end
% Calculate IntTermGovtBondReturn
ITGovBondReturn_projections = ones(20,10000);
for c = 1:10000
    for d = 1:20
        if d == 1
            ITGovBondReturn_projections(1,c) = ITGvtYld_Historical(1135) - 5* (ITGvtYld_projections(1,c) - ITGvtYld_Historical(1135));
        else
            ITGovBondReturn_projections(d,c) = ITGvtYld_projections(d-1,c) - 5* (ITGvtYld_projections(d,c) - ITGvtYld_projections(d-1,c));
        end
    end
end
% Growth of $1 in ITGovBonds
GovBond_growthofdollar = ones(21, 10000);
for e = 1:10000
    for f = 2:21
        GovBond_growthofdollar(f,e) = GovBond_growthofdollar(f-1,e) * (1 + ITGovBondReturn_projections(f-1,e));
    end
end
clearvars y X z regs bint r rint stats sd a b c d e f;
% ITGvtYld_Historical END–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––



% HIGHYIELDBONDRETURN BEGIN–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
HighYieldBond_Historical = table.IABarclaysUSHYCorporateBonds(10:1143);
HYB_projections = zeros(20,10000);
HighYieldBond_Historical = HighYieldBond_Historical/100;

rolling = zeros(1123, 1);
rolling2 = zeros(1111, 1);
logconv = zeros(12, 1);
for a = 1:1123
    for b = 1:12
        logconv(b) = log(1+HighYieldBond_Historical(a + b-1));
    end
    rolling(a) = sum(logconv);
    if (a>12)
        rolling2(a-12) = rolling(a);
    end
end
% these are carefully checked referencing our spreadsheet
y = rolling2(1:1111);
X = rolling(1:1111);
z = ITGvtYld_Historical(25:1135)-ITGvtYld_Historical(13:1123);
[regs,bint,r,rint,stats] = regress(y, [ones(1111,1) X z]);
sd = std(y);
% projections
for d = 1:10000
    for e = 1:20
        if e == 1
            HYB_projections(e,d) = regs(2)*rolling(1123) + (1-regs(2))*log(1.075) + regs(3)*(ITGvtYld_projections(e,d)-ITGvtYld_Historical(1135)) + (1-stats(1))*sd*normrnd(0,1);
        else
            HYB_projections(e,d) = regs(2)*HYB_projections(e-1,d) + (1-regs(2))*log(1.075) + regs(3)*(ITGvtYld_projections(e,d)-ITGvtYld_projections(e-1,d)) + (1-stats(1))*sd*normrnd(0,1);
        end
    end
end
HYB_projections = exp(HYB_projections)-1;
HYB_GrowthOfDollar = ones(21, 10000);
for d = 1:10000
    for e = 2:21
        HYB_GrowthOfDollar(e,d) = HYB_GrowthOfDollar(e-1, d) * (1+HYB_projections(e-1, d));
    end
end
% will need log returns of HYB for stock projections
LogHYB = rolling2;
clearvars a b y X z sd regs bint r rint stats d e;
% HIGHYIELDBONDRETURN END–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––



% LARGESTOCKRETURN BEGIN–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Stocks_Historical = table.IbbotsonSBBIUSLargeStockTRUSDTotalReturn(10:1143);
Stocks_projections = zeros(20,10000);
Stocks_Historical = Stocks_Historical/100;

rolling = zeros(1123, 1);
rolling2 = zeros(1111, 1);
logconv = zeros(12, 1);
for a = 1:1123
    for b = 1:12
        logconv(b) = log(1+Stocks_Historical(a + b-1));
    end
    rolling(a) = sum(logconv);
    if (a>12)
        rolling2(a-12) = rolling(a);
    end
end
y = rolling2(1:1111);
X = rolling(1:1111);
z = LogHYB(1:1111);
[regs,bint,r,rint,stats] = regress(y, [ones(1111,1) X z]);
sd = std(rolling);
for c = 1:10000
    for d = 1:20
        if d == 1
            Stocks_projections(1, c) = regs(2)*rolling(1123) + (1-regs(2))*log(1.090) + (regs(3))*LogHYB(1111) + (1-stats(1))*sd*normrnd(0,1);
        else
            Stocks_projections(d, c) = regs(2)*Stocks_projections(d-1,c) + (1-regs(2))*log(1.090) + regs(3)*(HYB_projections(d,c)) + (1-stats(1))*sd*normrnd(0,1);
        end
    end
end
Stocks_GrowthOfDollar = ones(21, 10000);
for d = 1:10000
    for e = 2:21
        Stocks_GrowthOfDollar(e,d) = Stocks_GrowthOfDollar(e-1, d) * (1+Stocks_projections(e-1, d));
    end
end
clearvars rolling rolling2 logconv a b y X z regs bing r rint stats sd c d e LogHYB;
%END LARGESTOCK–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

