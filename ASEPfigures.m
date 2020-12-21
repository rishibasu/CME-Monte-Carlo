

%COMPARE
bond5 = GovBond_growthofdollar(6,:);
bond10 = GovBond_growthofdollar(11,:);
bond15 = GovBond_growthofdollar(16,:);
bond20 = GovBond_growthofdollar(21,:);
stock5 = Stocks_GrowthOfDollar(6,:);
stock10 = Stocks_GrowthOfDollar(11,:);
stock15 = Stocks_GrowthOfDollar(16,:);
stock20 = Stocks_GrowthOfDollar(21,:);

comp5 = sum(stock5>bond5)/10000
comp10 = sum(stock10>bond10)/10000
comp15 = sum(stock15>bond15)/10000
comp20 = sum(stock20>bond20)/10000

figure (1)
boxplot([Stocks_GrowthOfDollar(6,:) Stocks_GrowthOfDollar(11,:) Stocks_GrowthOfDollar(16,:) Stocks_GrowthOfDollar(21,:)])

figure(2) 
boxplot(



%boxplots
inflation_data_plot=(inflation_growthofdollar([6 11 16 21],:))';
forHighYieldBond_Historical=(HYB_GrowthOfDollar([6 11 16 21],:))';
forstock=(Stocks_GrowthOfDollar([6 11 16 21],:))';

figure(1)
boxplot(inflation_growthofdollar([6 11 16 21],:))';



figure (1)
boxplot(ones(5,1))
figure (2)
boxplot(zeros(5,1))
figure (4)
boxplot ([Stocks_Historical ones(1134,1)])



half = ones(20, 10000);
twenty = ones(20, 10000);
eighty = ones(20, 10000);
half = .5*log(1+ITGovBondReturn_projections) + .5*log(1+Stocks_projections);
twenty = .2*log(1+ITGovBondReturn_projections) + .8*log(1+Stocks_projections);
eighty = .8*log(1+ITGovBondReturn_projections) + .2*log(1+Stocks_projections);

twenty_growth = zeroes(20,10000);
twenty_growth(1,:)=sum(

boxplot(Stocks_GrowthOfDollar(6,:),Stocks_GrowthOfDollar(11,:),Stocks_GrowthOfDollar(16,:),Stocks_GrowthOfDollar(21,:))


boxplot(Stocks_GrowthOfDollar(6,:), Stocks_GrowthOfDollar(11,:))
