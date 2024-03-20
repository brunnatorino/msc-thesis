
% calculating Svensson

dataset = readtable("C:\Users\torin\OneDrive\Desktop\EconDev\Thesis\Yield\TEST_BrazilianFixedHistorical.csv");
weekdays = unique(dataset{:,"Date"});

% initialise table 
tab1 = table(0,1,2,3,4,5,datetime(2024,1,1));
tab1.Properties.VariableNames=["params1","params2","params3","params4","params5","params6","params7"];

for idx = 1:numel(weekdays)
    try
        i = weekdays(idx);
        matches = (dataset.Date == i);
        data = dataset(matches,:);
        
        Maturity = datenum(data{:,"Maturity"});
        CouponRate = data{:,"CouponRate"};
        InstrumentPeriod = data{:,"InstrumentPeriod"};
        CleanPrice = data{:,"MidPrice"};
        
        Settle = repmat(datenum(i),[height(data) 1]);
        CurveSettle = datenum(i);
        Redemption = repmat(1000,[height(data) 1]);
        
        Instruments = [Settle Maturity CleanPrice CouponRate];
           
        SvenssonModel = IRFunctionCurve.fitSvensson('Zero',CurveSettle,...
            Instruments,'InstrumentPeriod',InstrumentPeriod);
        
        %[Beta0,Beta1,Beta2,Beta3,tau1,tau2].
        params = SvenssonModel.Parameters;
        params(end+1)=datenum(i);
        t1 = array2table(params);
        t1.params7 = datetime(t1.params7,'ConvertFrom','datenum');
    
    
        tab1 = [tab1;t1];
    catch
        % do nothing
    end

end

