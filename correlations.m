getready = table((9:1143), (2:13));
%done = table2array(getready);

precor = table2array(getready(:, [1:5 7:12]));
corrplot(precor)
plotedit on


%double2 = zeros(631, 12);
%for n = 1:12
%    double2(:, n)=table2array(getready((505:1135), n));
%end
%corrplot(double2)