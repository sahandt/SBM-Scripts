CatalogueClearAll();

CreateNewMetricProject();

local liqcat =AddNewCatalogue("Fluid Process", "");
CatalogueAddType(liqcat, 'PIPE','PIPE_FITTING', 'PIPE_INSULATION','PIPE_FLANGE');  
CatalogueAddType(liqcat ,"RECT_AS_TANK","VCYL_AS_TANK","HCYL_AS_TANK"); 
CatalogueAddType(liqcat , 'HYDRAULIC_APPLIANCE',"PUMP");  
CatalogueAddType(liqcat, "GPVALVE","FCVALVE","TCVALVE","PRVALVE","PSVALVE","PBVALVE","CHVALVE"); 

local pipecat =AddNewCatalogue("Pipes", liqcat);
CatalogueAddType(pipecat, 'PIPE','PIPE_FITTING','PIPE_INSULATION','PIPE_FLANGE'); 

local catb3610 =AddNewCatalogue("ASME/ANSI B36.10/19 - Carbon, Alloy and Stainless Steel Pipes", pipecat);
CatalogueAddType(catb3610, 'PIPE'); 

local catb80 =AddNewCatalogue("ASTM B88 - Seamless Copper Water Tubes", pipecat);
CatalogueAddType(catb80, 'PIPE'); 

 local fitcat =AddNewCatalogue("Pipe Fittings", liqcat);
 CatalogueAddType( fitcat , 'PIPE_FITTING'); 

 local flgcat =AddNewCatalogue("Pipe Flanges", liqcat);
 CatalogueAddType( flgcat , 'PIPE_FLANGE'); 

 local gflgcat =AddNewCatalogue("Generic Flanges, ASME B16.5", flgcat);
 CatalogueAddType( gflgcat , 'PIPE_FLANGE'); 


 local pincat =AddNewCatalogue("Pipe Insulations", liqcat);
 CatalogueAddType( pincat , 'PIPE_INSULATION');  


local valvecat =AddNewCatalogue("Valves", liqcat);
CatalogueAddType(valvecat, "GPVALVE","FCVALVE","TCVALVE","PRVALVE","PSVALVE","PBVALVE","CHVALVE"); 


 local tankcat =AddNewCatalogue("Tanks", liqcat);
 CatalogueAddType( tankcat ,"RECT_AS_TANK","VCYL_AS_TANK","HCYL_AS_TANK","TANK_INSULATION"); 

 local rtankcat =AddNewCatalogue("Generic Rectangular Tanks", tankcat);
 CatalogueAddType(  rtankcat  ,"RECT_AS_TANK");  

 local vctankcat =AddNewCatalogue("Generic Vertical Cylindrical Tanks", tankcat);
 CatalogueAddType( vctankcat,"VCYL_AS_TANK");  

 local hctankcat =AddNewCatalogue("Generic Horizontal Cylindrical Tanks", tankcat);
 CatalogueAddType(  hctankcat,"HCYL_AS_TANK");  

 local tankincat =AddNewCatalogue("Tank Insulations", tankcat);
 CatalogueAddType(  tankincat,"TANK_INSULATION");   

local happcat =AddNewCatalogue("Hydraulic Appliances", liqcat);
CatalogueAddType(happcat, 'HYDRAULIC_APPLIANCE',"PUMP");      

local pumpcat =AddNewCatalogue( "Pumps", happcat);
CatalogueAddType( pumpcat  , "PUMP");   

local centrpumpcat =AddNewCatalogue( "Generic Pumps",pumpcat);
CatalogueAddType( centrpumpcat , "PUMP");   


MaterialClearCollection();
MaterialAddtoCollection("CarbonSteel","S30")
local matName = MaterialGetProperty("CarbonSteel",'NAME'); 

MaterialAddtoCollection("SS304","S40")
local ss304matName = MaterialGetProperty("SS304",'NAME'); 

MaterialAddtoCollection("SS316","S60")
local ss316matName = MaterialGetProperty("SS316",'NAME'); 

MaterialAddtoCollection("Copper","S90")
local cmatName = MaterialGetProperty("Copper",'NAME'); 

MaterialAddtoCollection("GMW","S510")
local gmwmatName = MaterialGetProperty("GMW",'NAME'); 


InputClear();
InputAddPoint(0,0,0);


for ftag in CreateElement('PIPE_FITTING') do 
             local elef_type = GetElementType(ftag);
             if elef_type=="PIPE_FITTING" then 
                SetProperty(ftag,'KEYWORD_1',"Pipe fitting");
                SetProperty(ftag,'MANUFACTURER',"Generic");

                SetProperty(ftag,'FITTING_MATERIAL',"S30");  
                SetProperty(ftag,'NAME',"Generic pipe fitting, "..matName );  
                SetProperty(ftag,'KEYWORD_2',matName);
                SetProperty(ftag,'ABSOLUTE_ROUGHNESS',0.000045);

                local newprodfitf1 = ProductCreateFromElement(fitcat,ftag);

                SetProperty(ftag,'FITTING_MATERIAL',"S90");  
                SetProperty(ftag,'NAME',"Generic pipe fitting, "..cmatName );  
                SetProperty(ftag,'KEYWORD_2',cmatName);
                SetProperty(ftag,'ABSOLUTE_ROUGHNESS',0.0000015);

                local newprodfitf2 = ProductCreateFromElement(fitcat,ftag);

                ActivateProduct(newprodfitf1);
            end
end

InputAddPoint(1,0,0);
local  newprod1;

for tag in CreateElement('PIPE') do
             local ele_type = GetElementType(tag);
             if ele_type=="PIPE" then 

                      SetProperty(tag,'MANUFACTURER',"Generic");

                      SetProperty(tag,'KEYWORD_1',matName.." Pipe");
                      SetProperty(tag,'KEYWORD_2',"ASME-ANSI B36.10");
                      SetProperty(tag,'PIPE_MATERIAL',"S30"); 
                      SetProperty(tag,'ABSOLUTE_ROUGHNESS',0.000045);
                      local Schs= GetPipeDimensionsB3610();
                      for schi,schj in ipairs(Schs) do 
                             local sn = schj[1];
                             local subcat3610 =AddNewCatalogue(sn, catb3610);
                            CatalogueAddType(subcat3610, 'PIPE'); 
                            for schi2,schj2 in ipairs(schj[2]) do 
                                SetProperty(tag,'NAME',matName.. " Pipe, ".. schj2[1] .."\" NPS, ".. sn..", ASME-ANSI B36.10" );  
                                SetProperty(tag,'OUTSIDE_DIAMETER',schj2[2]);  
                                SetProperty(tag,'WALL_THICKNESS',schj2[3]);  
                                SetProperty(tag,'FITTING1LENGTH',schj2[2]*1.5);  
                                SetProperty(tag,'FITTING2LENGTH',schj2[2]*1.5);  

                               newprod1 = ProductCreateFromElement(subcat3610,tag);

                            end
                       end

                      ActivateProduct(newprod1);

                      SetProperty(tag,'KEYWORD_1',cmatName.." Seamless Pipe");
                      SetProperty(tag,'KEYWORD_2',"ASTM B88");
                      SetProperty(tag,'PIPE_MATERIAL',"S90"); 
                      SetProperty(tag,'ABSOLUTE_ROUGHNESS',0.0000015);

                      Schs= GetPipeDimensionsB88();

                      for schi,schj in ipairs(Schs) do 
                             local sn = schj[1];
                             local subcatb80 =AddNewCatalogue(sn, catb80);
                            CatalogueAddType(subcatb80, 'PIPE'); 
                            for schi2,schj2 in ipairs(schj[2]) do 
                                SetProperty(tag,'NAME',cmatName.. " Seamless Water Tube, ".. schj2[1] .."\" NPS, ".. sn..", ASTM B88" );  
                                SetProperty(tag,'OUTSIDE_DIAMETER',schj2[2]);  
                                SetProperty(tag,'WALL_THICKNESS',schj2[3]);  
                                SetProperty(tag,'FITTING1LENGTH',schj2[2]*1.5);  
                                SetProperty(tag,'FITTING2LENGTH',schj2[2]*1.5);  

                               newprod1 = ProductCreateFromElement(subcatb80,tag);
                            end
                       end
             end
end

InputClear();
InputAddPoint(0,0,0);

local pipeODs = GetOutsideDiametersB3610();

function GetPipeOD(ODs, NPS)
   for i, odi in ipairs(ODs) do 
      if odi[1]==NPS then
          return odi[2]
      end
   end
   print("Can not find pipe OD: "..NPS)
   return 0;
end

for tag in CreateElement('PIPE_FLANGE') do
             local ele_type = GetElementType(tag);
             if ele_type=="PIPE_FLANGE" then 

                      SetProperty(tag,'MANUFACTURER',"Generic");
                      SetProperty(tag,'KEYWORD_1',"Pipe flange");
                      SetProperty(tag,'KEYWORD_2',matName);
                      SetProperty(tag,'FLANGE_MATERIAL',"S30"); 

                      local fldims= GetFlangeDimensionsB165();
                      for i, flgj in ipairs(fldims) do 
                         local classname= flgj [1];
                         local classinfo = flgj[2];
                         local classcat =AddNewCatalogue("Class "..classname, gflgcat);
                         CatalogueAddType(classcat, 'PIPE_FLANGE'); 
                         for j, sizej in ipairs(classinfo) do 

                              local nps= sizej[1];
                              local od= sizej[2];
                              local thk= sizej[3];
                              local bcd= sizej[4];
                              local bhd= sizej[5];
                              local bn= sizej[6];
                              local bs= sizej[7];
                              local ID= GetPipeOD(pipeODs, nps)+ 0.0015875;

                              SetProperty(tag,'NAME',"Generic Flange, " ..matName..", Class "..classname..", "..nps.." NPS, ASME B16.5"); 
                              SetProperty(tag,'OUTSIDE_DIAMETER',od); 
                              SetProperty(tag,'WALL_THICKNESS',thk); 
                              SetProperty(tag,'BOLT_CIRCLE_DIAMETER',bcd); 
                              SetProperty(tag,'HOLE_DIAMETER',bhd); 
                              SetProperty(tag,'HOLE_NUMBER',bn); 
                              SetProperty(tag,'INSIDE_DIAMETER',ID); 

                              newprod1 = ProductCreateFromElement(classcat ,tag);
                         end
                      end
             end
end

local InsThck ={}
InsThck[1] =0.125;
InsThck[2] =0.25;
InsThck[3] =0.375;
InsThck[4] =0.5;
InsThck[5] =0.75;
InsThck[6] =1;
InsThck[7] =1.5;
InsThck[8] =2;

local newprodpin;
for i, thick in ipairs(InsThck) do 

     for pintag in CreateElement("PIPE_INSULATION" ) do

             local ele_type = GetElementType( pintag );
             if ele_type== "PIPE_INSULATION"  then 
                      SetProperty(pintag,'MANUFACTURER',"Generic");
                      SetProperty(pintag,'KEYWORD_1',gmwmatName);
                      SetProperty(pintag,'KEYWORD_2',"Pipe Insulation");
                      SetProperty(pintag,'NAME',"Pipe insulation, "..gmwmatName..", ".. Double2Fraction (thick).."\" thick" );
                      SetLayersCount(pintag, 1)
                      SetLayerMaterialID(pintag,0,"S510");
                      SetLayerThickness(pintag,0,thick* 25.4 / 1000);  
                      newprodpin = ProductCreateFromElement(pincat ,pintag);
             end
    end
    ActivateProduct(newprodpin);
end

InputAddPoint(0,0,0);

local valven = {};
                   valven[1]=  "Check";
                   valven[2]=  "Pressure Breaker";
                   valven[3]=  "Pressure Reducing";
                   valven[4]=  "Pressure Sustaining ";
                   valven[5]=  "Trottle Control";
                   valven[6]=  "General Purpose"; 
                   valven[7]=  "Flow Control";

local valvet = {};
                   valven["CHVALVE"]=  "Check";
                   valven["PBVALVE"]=  "Pressure Breaker";
                   valven["PRVALVE"]=  "Pressure Reducing";
                   valven["PSVALVE"]=  "Pressure Sustaining ";
                   valven["TCVALVE"]=  "Trottle Control";
                   valven["GPVALVE"]=  "General Purpose"; 
                   valven["FCVALVE"]=  "Flow Control";

                   valvet[1]=  "CHVALVE";
                   valvet[2]=  "PBVALVE";
                   valvet[3]=  "PRVALVE";
                   valvet[4]=  "PSVALVE";
                   valvet[5]=  "TCVALVE";
                   valvet[6]=  "GPVALVE"; 
                   valvet[7]=  "FCVALVE";

for i,valvename in ipairs(valven) do 
     local valvetag = valvet[i];
     print(valvetag.." : "..valvename);
     for valtag in CreateElement( valvetag ) do

             local ele_type = GetElementType( valtag );
             if ele_type== valvetag  then 
                      SetProperty(valtag,'MANUFACTURER',"Generic");
                      SetProperty(valtag,'KEYWORD_1',matName);
                      SetProperty(valtag,'KEYWORD_2',valvename.." Valve");
                      SetProperty(valtag,'VALVE_MATERIAL',"S30");  
                      SetProperty(valtag,'ABSOLUTE_ROUGHNESS',0.000045); 
                      SetProperty(valtag,'NAME',"Generic "..valvename.." Valve, "..matName);
                      SetProperty(valtag,'OUTSIDE_DIAM',0.25);  
                      SetProperty(valtag,'WALL_THICKNESS',0.03);  
                      print("Creating valve product:"..valvename);
                       newprodv = ProductCreateFromElement(valvecat ,valtag);
             end
    end
end

InputClear();
InputAddPoint(0,0,0);

function GenerateRectangularTankProduct(rttag, length,  width,  height,thickness,  volume_gal,  body_material_name ) 
                SetProperty(rttag,'NAME',"Generic Rectangular atmospheric storage tank, "..volume_gal.." Gal, "..Round(length ,1).."x"..Round(width, 1).."x"..Round(height, 1).."m , ".. body_material_name);  
                SetProperty(rttag,'KEYWORD_1',"rectangular atmospheric storage tank");
                SetProperty(rttag,'KEYWORD_2',body_material_name);
                SetProperty(rttag,'MANUFACTURER',"Generic");
                SetProperty(rttag,'TANK_WALL_MATERIAL',"S30");  
                SetProperty(rttag,'APPLIANCE_TYPE','GENERIC_RECTANGULAR_TANK')
                SetProperty(rttag,'LENGTH',length);
                SetProperty(rttag,'WIDTH',width);  
                SetProperty(rttag,'HEIGHT',height);  

                newprodfitf1 = ProductCreateFromElement(rtankcat,rttag);
end


for rttag in CreateElement('RECT_AS_TANK') do 
             local elef_type = GetElementType(rttag);
             if elef_type=="RECT_AS_TANK" then 
               GenerateRectangularTankProduct(rttag,1, 1, 1, 0.003175, 220, matName);
               GenerateRectangularTankProduct(rttag,1.373, 1.22, 0.61, 0.003175, 225, matName);
               GenerateRectangularTankProduct(rttag,1.474, 1.22, 0.61, 0.003175, 240, matName);
               GenerateRectangularTankProduct(rttag,1.525, 0.915, 0.815, 0.003175, 250, matName);
               GenerateRectangularTankProduct(rttag,1.22, 1.22, 0.915, 0.003175, 300, matName);
               GenerateRectangularTankProduct(rttag,1.5, 1, 1, 0.003175, 330, matName);
               GenerateRectangularTankProduct(rttag,1.1, 1, 1.5, 0.003175, 330, matName);
               GenerateRectangularTankProduct(rttag,1.22, 1.22, 1.067, 0.003175, 350, matName);
               GenerateRectangularTankProduct(rttag,1.525, 1.143, 0.915, 0.003175, 350, matName);
               GenerateRectangularTankProduct(rttag,1.22, 1.22, 1.22, 0.003175, 400, matName);
               GenerateRectangularTankProduct(rttag,2, 1, 1, 0.003175, 440, matName);
               GenerateRectangularTankProduct(rttag,1, 1, 2, 0.003175, 440, matName);
               GenerateRectangularTankProduct(rttag,1.5, 1.5, 1, 0.003175, 495, matName);
               GenerateRectangularTankProduct(rttag,1.5, 1, 1.5, 0.003175, 495, matName);
               GenerateRectangularTankProduct(rttag,1.83, 1.22, 1.017, 0.003175, 500, matName);
               GenerateRectangularTankProduct(rttag,2.5, 1, 1, 0.003175, 550, matName);
               GenerateRectangularTankProduct(rttag,1.83, 1.22, 1.22, 0.003175, 600, matName);
               GenerateRectangularTankProduct(rttag,2.135, 1.067, 1.22, 0.003175, 600, matName);
               GenerateRectangularTankProduct(rttag,1.5, 1, 2, 0.003175, 660, matName);
               GenerateRectangularTankProduct(rttag,2, 1, 1.5, 0.003175, 660, matName);
               GenerateRectangularTankProduct(rttag,2, 1.5, 1, 0.003175, 660, matName);
               GenerateRectangularTankProduct(rttag,2.135, 1.525, 0.915, 0.003175, 660, matName);
               GenerateRectangularTankProduct(rttag,3, 1, 1, 0.003175, 660, matName);
               GenerateRectangularTankProduct(rttag,1.5, 1.5, 1.5, 0.003175, 743, matName);
               GenerateRectangularTankProduct(rttag,2.135, 1.373, 1.22, 0.003175, 780, matName);
               GenerateRectangularTankProduct(rttag,2.44, 1.22, 1.22, 0.003175, 800, matName);
               GenerateRectangularTankProduct(rttag,2, 1, 2, 0.003175, 880, matName);
               GenerateRectangularTankProduct(rttag,2, 2, 1, 0.003175, 880, matName);
               GenerateRectangularTankProduct(rttag,4, 1, 1, 0.003175, 880, matName);
               GenerateRectangularTankProduct(rttag,1.5, 1.5, 2, 0.003175, 990, matName);
               GenerateRectangularTankProduct(rttag,3, 1, 1.5, 0.003175, 990, matName);
               GenerateRectangularTankProduct(rttag,2, 1.5, 1.5, 0.003175, 990, matName);
               GenerateRectangularTankProduct(rttag,3, 1.5, 1, 0.003175, 990, matName);
               GenerateRectangularTankProduct(rttag,2.44, 1.525, 1.22, 0.003175, 1000, matName);
               GenerateRectangularTankProduct(rttag,3.05, 1.22, 1.22, 0.003175, 1000, matName);
               GenerateRectangularTankProduct(rttag,5, 1, 1, 0.003175, 1100, matName);
               GenerateRectangularTankProduct(rttag,2.5, 2, 1, 0.003175, 1100, matName);
               GenerateRectangularTankProduct(rttag,2.5, 1, 2, 0.003175, 1100, matName);
               GenerateRectangularTankProduct(rttag,2.135, 1.83, 1.296, 0.003175, 1116, matName);
               GenerateRectangularTankProduct(rttag,3.05, 1.525, 1.22, 0.003175, 1250, matName);
               GenerateRectangularTankProduct(rttag,2, 1.5, 2, 0.003175, 1320, matName);
               GenerateRectangularTankProduct(rttag,2, 2, 1.5, 0.003175, 1320, matName);
               GenerateRectangularTankProduct(rttag,3, 1, 2, 0.003175, 1320, matName);
               GenerateRectangularTankProduct(rttag,3, 2, 1, 0.003175, 1320, matName);
               GenerateRectangularTankProduct(rttag,4, 1, 1.5, 0.003175, 1320, matName);
               GenerateRectangularTankProduct(rttag,4, 1.5, 1, 0.003175, 1320, matName);
               GenerateRectangularTankProduct(rttag,3, 1.5, 1.5, 0.003175, 1485, matName);
               GenerateRectangularTankProduct(rttag,3.05, 1.525, 1.525, 0.003175, 1500, matName);
               GenerateRectangularTankProduct(rttag,3.05, 1.83, 1.22, 0.003175, 1500, matName);
               GenerateRectangularTankProduct(rttag,3.5, 2, 1, 0.003175, 1540, matName);
               GenerateRectangularTankProduct(rttag,7, 1, 1, 0.003175, 1540, matName);
               GenerateRectangularTankProduct(rttag,2, 2, 2, 0.003175, 1760, matName);
               GenerateRectangularTankProduct(rttag,4, 2, 1, 0.003175, 1760, matName);
               GenerateRectangularTankProduct(rttag,2.595, 2.595, 1.22, 0.003175, 1800, matName);
               GenerateRectangularTankProduct(rttag,3, 2, 1.5, 0.003175, 1980, matName);
               GenerateRectangularTankProduct(rttag,3.05, 2.44, 1.22, 0.003175, 2000, matName);
               GenerateRectangularTankProduct(rttag,5, 2, 1, 0.003175, 2200, matName);
               GenerateRectangularTankProduct(rttag,5, 1, 2, 0.003175, 2200, matName);
               GenerateRectangularTankProduct(rttag,2.5, 2, 2, 0.003175, 2200, matName);
            end
end

function GenerateVerticalTankProduct(vcttag, diameter,  height,thickness,  volume_gal,  body_material_name ) 
                SetProperty(vcttag,'NAME',"Generic vertical cylindrical atmospheric storage tank, "..volume_gal.." Gal, "..Round(diameter ,1).."x"..Round(height, 1).."m , ".. body_material_name);  
                SetProperty(vcttag,'KEYWORD_1',"vertical cylindrical atmospheric storage tank");
                SetProperty(vcttag,'KEYWORD_2',body_material_name);
                SetProperty(vcttag,'MANUFACTURER',"Generic");
                SetProperty(vcttag,'TANK_WALL_MATERIAL',"S30");  
                SetProperty(vcttag,'APPLIANCE_TYPE','GENERIC_VERTICAL_TANK')
                SetProperty(vcttag,'DIAMETER',diameter); 
                SetProperty(vcttag,'HEIGHT',height);  

                newprodfitf1 = ProductCreateFromElement(vctankcat,vcttag);
end

for vcttag in CreateElement('VCYL_AS_TANK') do 
             local elef_type = GetElementType(vcttag);
             if elef_type=="VCYL_AS_TANK" then 
            
                 GenerateVerticalTankProduct(vcttag,0.762,1.2192, 0.002656, 150, matName);
                 GenerateVerticalTankProduct(vcttag,0.9652,1.524, 0.002656, 300, matName);
                 GenerateVerticalTankProduct(vcttag,1.2192,1.8288, 0.002656, 550, matName);
                 GenerateVerticalTankProduct(vcttag,1.6256, 1.8288,0.003416 , 1000, matName);
                 GenerateVerticalTankProduct(vcttag,1.6256,2.7432,0.004554 , 1500, matName);
                 GenerateVerticalTankProduct(vcttag,1.6256,3.6576, 0.0047625 , 2000, matName);
                 GenerateVerticalTankProduct(vcttag,1.6256,4.572, 0.0047625, 2500, matName);
                 GenerateVerticalTankProduct(vcttag,1.8288,4.2672, 0.0047625, 3000, matName);
                 GenerateVerticalTankProduct(vcttag,2.4384,3.3528, 0.0047625, 4000, matName);
                 GenerateVerticalTankProduct(vcttag,2.4384,4.064, 0.0047625, 5000, matName);
                 GenerateVerticalTankProduct(vcttag,2.4384,4.8768, 0.0047625, 6000, matName);
                 GenerateVerticalTankProduct(vcttag,2.4384,6.5024, 0.0047625, 8000, matName);
                 GenerateVerticalTankProduct(vcttag,3.048,4.2672, 0.0047625, 8000, matName);
                 GenerateVerticalTankProduct(vcttag,3.2004, 4.8768, 0.0047625, 10000, matName);
                 GenerateVerticalTankProduct(vcttag,3.2004,5.4864, 0.0047625, 12000, matName);
                 GenerateVerticalTankProduct(vcttag,3.2004,7.3152, 0.0047625, 15000, matName);
                 GenerateVerticalTankProduct(vcttag,3.2004,9.4488,0.00635 , 20000, matName);
                 GenerateVerticalTankProduct(vcttag,3.6576,9.144, 0.00635, 25000, matName);
                 GenerateVerticalTankProduct(vcttag,3.6576,10.668, 0.00635, 30000, matName);
    end
end


function GenerateHorizontalTankProduct(hcttag, diameter,  length, thickness,  volume_gal,  body_material_name ) 
                SetProperty(hcttag,'NAME',"Generic horizontal cylindrical atmospheric storage tank, "..volume_gal.." Gal, "..Round(diameter ,1).."x"..Round(length, 1).."m , ".. body_material_name);  
                SetProperty(hcttag,'KEYWORD_1',"vertical cylindrical atmospheric storage tank");
                SetProperty(hcttag,'KEYWORD_2',body_material_name);
                SetProperty(hcttag,'MANUFACTURER',"Generic");
                SetProperty(hcttag,'TANK_WALL_MATERIAL',"S30");  
                SetProperty(hcttag,'APPLIANCE_TYPE','GENERIC_HORIZONTAL_TANK')

                SetProperty(hcttag,'DIAMETER',diameter); 
                SetProperty(hcttag,'LENGTH',length);   

                newprodfitf1 = ProductCreateFromElement(hctankcat,hcttag);
end

for hcttag in CreateElement('HCYL_AS_TANK') do 
             local elef_type = GetElementType(hcttag);
             if elef_type=="HCYL_AS_TANK" then 
                   GenerateHorizontalTankProduct(hcttag,1.2192, 1.8288, 0.0047625, 550, matName);
                   GenerateHorizontalTankProduct(hcttag,1.2192, 3.302, 0.0047625, 1000, matName);
                   GenerateHorizontalTankProduct(hcttag,1.2192, 3.6322, 0.0047625, 1100, matName);
                   GenerateHorizontalTankProduct(hcttag,1.2192, 4.7752, 0.0047625, 1500, matName);
                   GenerateHorizontalTankProduct(hcttag,1.651, 2.7432, 0.0047625, 1500, matName);
                   GenerateHorizontalTankProduct(hcttag,1.651, 3.6068, 0.0047625, 2000 , matName);
                   GenerateHorizontalTankProduct(hcttag,1.651, 4.5212 , 0.0047625, 2500, matName);
                   GenerateHorizontalTankProduct(hcttag,1.651, 5.3848 , 0.0047625, 3000 , matName);
                   GenerateHorizontalTankProduct(hcttag,1.651, 7.2136 , 0.0047625, 4000 , matName);
                   GenerateHorizontalTankProduct(hcttag,1.8288, 7.2136, 0.00635, 5000 , matName);
                   GenerateHorizontalTankProduct(hcttag,2.1336, 5.3848, 0.00635, 5000 , matName);
                   GenerateHorizontalTankProduct(hcttag,2.1336, 8.0772, 0.00635, 7500 , matName);
                   GenerateHorizontalTankProduct(hcttag,2.4384, 5.9944, 0.00635, 7500 , matName);
                   GenerateHorizontalTankProduct(hcttag,2.4384, 8.0772, 0.00635, 10000, matName);
                   GenerateHorizontalTankProduct(hcttag,3.048, 5.1816, 0.00635, 10000, matName);
                   GenerateHorizontalTankProduct(hcttag,2.4384,9.6012 , 0.00635, 12000, matName);
                   GenerateHorizontalTankProduct(hcttag,3.048, 6.2992, 0.00635, 12000, matName);
                   GenerateHorizontalTankProduct(hcttag,2.7432, 9.6012, 0.0079375, 15000, matName);
                   GenerateHorizontalTankProduct(hcttag,3.048, 7.7724 , 0.0079375, 15000, matName);
                   GenerateHorizontalTankProduct(hcttag,3.048,10.5156 , 0.0079375, 20000, matName);
                   GenerateHorizontalTankProduct(hcttag,3.048, 12.954, 0.009525, 25000, matName);
                   GenerateHorizontalTankProduct(hcttag,3.048,15.621 , 0.009525, 30000, matName);                  
    end
end

local newprodtin;
for i, thick in ipairs(InsThck) do 

     for tintag in CreateElement("TANK_INSULATION" ) do

             local ele_type = GetElementType( tintag );
             if ele_type== "TANK_INSULATION"  then 
                      SetProperty(tintag,'MANUFACTURER',"Generic");
                      SetProperty(tintag,'KEYWORD_1',gmwmatName);
                      SetProperty(tintag,'KEYWORD_2',"Tank Insulation");
                      SetProperty(tintag,'NAME',"Tank insulation, "..gmwmatName..", ".. Double2Fraction (thick).."\" thick" );
                      SetLayersCount(tintag, 1)
                      SetLayerMaterialID(tintag,0,"S510");
                      SetLayerThickness(tintag,0,thick* 25.4 / 1000);  
                      newprodtin = ProductCreateFromElement(tankincat ,tintag);
             end
    end
    ActivateProduct(newprodtin);
end

for tag in CreateElement('HYDRAULIC_APPLIANCE')  do
        local ele_type = GetElementType(tag);
        if ele_type=="HYDRAULIC_APPLIANCE" then 

                  SetProperty(tag,'APPLIANCE_TYPE','GENERIC_HYDRAULIC_APPLIANCE');
                  SetProperty(tag,'LENGTH',0.75 );
                  SetProperty(tag,'WIDTH',0.75 );
                  SetProperty(tag,'HEIGHT',0.75 );

                  SetProperty(tag,'NAME','Generic Rectangular Hydraulic Appliance') 
                  SetProperty(tag,'PART_NUMBER','GHYA-001' );
                  SetProperty(tag,'SHAPE',0 );
                  local newprod1 = ProductCreateFromElement(happcat,tag);

                  SetProperty(tag,'NAME','Generic Vertical Cylindrical Hydraulic Appliance') 
                  SetProperty(tag,'PART_NUMBER','GHYA-002' );
                  SetProperty(tag,'SHAPE',1 );
                  SetProperty(tag,'DIAMETER',0.75 );
                  local newprod1 = ProductCreateFromElement(happcat,tag);

                  SetProperty(tag,'NAME','Generic Horizontal Cylindrical Hydraulic Appliance') 
                  SetProperty(tag,'PART_NUMBER','GHYA-003' );
                  SetProperty(tag,'SHAPE',2 );
                  local newprod1 = ProductCreateFromElement(happcat,tag);

                  SetProperty(tag,'NAME','Generic Spherical Hydraulic Appliance') 
                  SetProperty(tag,'PART_NUMBER','GHYA-004' );
                  SetProperty(tag,'SHAPE',3 );
                  local newprod1 = ProductCreateFromElement(happcat,tag);
        end
end

for tag in CreateElement('PUMP')  do
        local ele_type = GetElementType(tag);
        if ele_type=="PUMP" then 
          InputClear();
          InputAddElement(tag)

           local motor_tag=""
           for tagel in CreateElement('ELECTRIC_APPLIANCE')  do
               local ele_type2 = GetElementType(tagel);
               if ele_type2=="ELECTRIC_APPLIANCE" then 
               motor_tag=tagel;
               end
            end

          InputAddPoint(0,0,0);

           local inlet_tag=""
           for tag3 in CreateElement('PIPE_FITTING')  do
               local ele_type3 = GetElementType(tag3);
               if ele_type3=="PIPE_FITTING" then 
               inlet_tag=tag3;
               end
            end


           local outlet_tag=""
           for tag4 in CreateElement('PIPE_FITTING')  do
               local ele_type4 = GetElementType(tag4);
               if ele_type4=="PIPE_FITTING" then 
               outlet_tag=tag4;
               end
            end

                  SetProperty(motor_tag,'NAME','Generic Electric Motor')
                  SetProperty(motor_tag,'APPLIANCE_TYPE','GENERIC_ELECTRICAL_MOTOR')
                  SetProperty(motor_tag,'SHAPE',0 );
                  SetProperty(motor_tag,'LENGTH',0.3 );
                  SetProperty(motor_tag,'WIDTH',0.5 );
                  SetProperty(motor_tag,'HEIGHT',0.3 );
                  SetProperty(motor_tag,'OFFSET_Z',-0.065 );
                  SetProperty(motor_tag,'CONNECTION_LENGTH' ,0.25 );
                  SetProperty(motor_tag,'VOLTAGE',115 );
                  SetProperty(motor_tag,'CURRENT',1.2 );
                  SetProperty(motor_tag,'POWER',300 );
                  SetProperty(motor_tag,'PART_NUMBER','GEM-001' );

                SetProperty(inlet_tag,'KEYWORD_1',"Pump inlet");
                SetProperty(inlet_tag,'MANUFACTURER',"Generic");
                SetProperty(inlet_tag,'FITTING_MATERIAL',"S30");  
                SetProperty(inlet_tag,'NAME',"Generic pump inlet" );  
                SetProperty(inlet_tag,'KEYWORD_2',"pump inlet");
                SetProperty(inlet_tag,'AUTOSIZE', false); 
                SetProperty(inlet_tag,'OUTSIDE_DIAMETER', 0.168275);
                SetProperty(inlet_tag,'WALL_THICKNESS', 0.007112); 
                SetProperty(inlet_tag,'CONNECTION_LENGTH', 0.04);
                SetProperty(inlet_tag,'SIDE', 1); 
                SetProperty(inlet_tag,'OFFSET_X', 0);
                SetProperty(inlet_tag,'OFFSET_Z', 0);
 
                SetProperty(outlet_tag,'KEYWORD_1',"Pump outlet");
                SetProperty(outlet_tag,'MANUFACTURER',"Generic");
                SetProperty(outlet_tag,'FITTING_MATERIAL',"S30");  
                SetProperty(outlet_tag,'NAME',"Generic pump outlet" );  
                SetProperty(outlet_tag,'KEYWORD_2',"pump outlet");
                SetProperty(outlet_tag,'AUTOSIZE', false); 
                SetProperty(outlet_tag,'OUTSIDE_DIAMETER', 0.0889);
                SetProperty(outlet_tag,'WALL_THICKNESS', 0.005486); 
                SetProperty(outlet_tag,'CONNECTION_LENGTH', -0.065);
                SetProperty(outlet_tag,'SIDE', 2); 
                SetProperty(outlet_tag,'CONNECTION_ANGLE', 3.927); 
                SetProperty(outlet_tag,'DIRECTION' , 2); 

                SetProperty(tag,'NAME','Generic Centrifugal Pump 3x6') 
                SetProperty(tag,'APPLIANCE_TYPE','GENERIC_CENTRIFUGAL_PUMP') 
                SetProperty(tag,'PART_NUMBER','GCPU-001' );
                SetProperty(tag,'LENGTH',0.1);
                SetProperty(tag,'DIAMETER',0.449); 
                SetProperty(tag,'HEAD_FLOW_CURVE_FORMULA',"-249*x+28"); 
                SetProperty(tag,'EFFICIENCY_FLOW_CURVE_FORMULA',"1"); 
                SetProperty(tag,'MIN_FLOW',0.011); 
                SetProperty(tag,'MAX_FLOW',0.047); 
                SetProperty(tag,'MAX_HEAD',33); 
                SetProperty(tag,'BODY_MATERIAL',"S30"); 

                local newprod1 = ProductCreateFromElement(centrpumpcat,tag);
                ActivateProduct(newprod1);

                SetProperty(motor_tag,'LENGTH',0.3 );
                SetProperty(motor_tag,'WIDTH',0.5 );
                SetProperty(motor_tag,'HEIGHT',0.3 );
                SetProperty(motor_tag,'OFFSET_Z',-0.065 );
                SetProperty(motor_tag,'CONNECTION_LENGTH' ,0.25 );
                SetProperty(motor_tag,'VOLTAGE',115 );
                SetProperty(motor_tag,'CURRENT',1.2 );
                SetProperty(motor_tag,'POWER',300 );
                SetProperty(motor_tag,'PART_NUMBER','GEM-002' );

                SetProperty(inlet_tag,'OUTSIDE_DIAMETER', 0.168275);
                SetProperty(inlet_tag,'WALL_THICKNESS', 0.007112); 
                SetProperty(inlet_tag,'CONNECTION_LENGTH', 0.04);

                SetProperty(outlet_tag,'OUTSIDE_DIAMETER', 0.1143);
                SetProperty(outlet_tag,'WALL_THICKNESS', 0.00602); 
                SetProperty(outlet_tag,'CONNECTION_LENGTH', -0.065);

                SetProperty(tag,'NAME','Generic Centrifugal Pump 4x6') 
                SetProperty(tag,'PART_NUMBER','GCPU-002' );
                SetProperty(tag,'LENGTH',0.125);
                SetProperty(tag,'DIAMETER',0.449); 
                SetProperty(tag,'HEAD_FLOW_CURVE_FORMULA',"-191*x+28"); 
                SetProperty(tag,'EFFICIENCY_FLOW_CURVE_FORMULA',"1"); 
                SetProperty(tag,'MIN_FLOW',0.022); 
                SetProperty(tag,'MAX_FLOW',0.0694); 
                SetProperty(tag,'MAX_HEAD',33); 

                local newprod2 = ProductCreateFromElement(centrpumpcat,tag);

                SetProperty(motor_tag,'LENGTH',0.3 );
                SetProperty(motor_tag,'WIDTH',0.5 );
                SetProperty(motor_tag,'HEIGHT',0.3 );
                SetProperty(motor_tag,'OFFSET_Z',-0.065 );
                SetProperty(motor_tag,'CONNECTION_LENGTH' ,0.25 );
                SetProperty(motor_tag,'VOLTAGE',115 );
                SetProperty(motor_tag,'CURRENT',1.2 );
                SetProperty(motor_tag,'POWER',300 );
                SetProperty(motor_tag,'PART_NUMBER','GEM-003' );

                SetProperty(inlet_tag,'OUTSIDE_DIAMETER', 0.219075);
                SetProperty(inlet_tag,'WALL_THICKNESS', 0.008179); 
                SetProperty(inlet_tag,'CONNECTION_LENGTH', 0.042);

                SetProperty(outlet_tag,'OUTSIDE_DIAMETER', 0.168275);
                SetProperty(outlet_tag,'WALL_THICKNESS', 0.007112); 
                SetProperty(outlet_tag,'CONNECTION_LENGTH', -0.065);

                SetProperty(tag,'NAME','Generic Centrifugal Pump 6x8') 
                SetProperty(tag,'PART_NUMBER','GCPU-003' );
                SetProperty(tag,'LENGTH',0.221);
                SetProperty(tag,'DIAMETER',0.56); 
                SetProperty(tag,'HEAD_FLOW_CURVE_FORMULA',"-103*x+25"); 
                SetProperty(tag,'EFFICIENCY_FLOW_CURVE_FORMULA',"1"); 
                SetProperty(tag,'MIN_FLOW',0.0416); 
                SetProperty(tag,'MAX_FLOW',0.111); 
                SetProperty(tag,'MAX_HEAD',28); 

                local newprod3 = ProductCreateFromElement(centrpumpcat,tag);

        end
end

CatalogueSave( liqcat, "Fluid Process catalogue");

ListCatalogues();
