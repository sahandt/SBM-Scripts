CatalogueClearAll();

CreateNewMetricProject();

local hvaccat =AddNewCatalogue("HVAC", "");
CatalogueAddType(hvaccat,'DUCT_FITTING' ,'CIRCULAR_DUCT','RECTANGULAR_DUCT','DUCT_INSULATION','HVAC_APPLIANCE'); 

local newcat =AddNewCatalogue("Duct Fittings", hvaccat);
CatalogueAddType(newcat, 'DUCT_FITTING');  
local subcat =AddNewCatalogue( "Generic Duct Fittings", newcat);
CatalogueAddType(subcat , 'DUCT_FITTING'); 

  InputClear();
  InputAddPoint(0,0,0);
  for tag in CreateElement('DUCT_FITTING')  do
        local ele_type = GetElementType(tag);
        if ele_type=="DUCT_FITTING" then 
                  SetProperty(tag,'NAME','Duct Fitting');
                  SetProperty(tag,'FITTING_MATERIAL',"S30"); 
                  SetProperty(tag,'PART_NUMBER','DF-001' );
                  local newprod1 = ProductCreateFromElement(subcat,tag);
                  ActivateProduct(newprod1 )
        end
end

local ductcat =AddNewCatalogue("Ducts", hvaccat); 
CatalogueAddType(ductcat, 'CIRCULAR_DUCT');   
CatalogueAddType(ductcat, 'RECTANGULAR_DUCT');   

local rdcat =AddNewCatalogue("Rectangular Ducts", ductcat);
CatalogueAddType(rdcat, 'RECTANGULAR_DUCT');  

local circat =AddNewCatalogue("Circular Ducts", ductcat);
CatalogueAddType(circat, 'CIRCULAR_DUCT');   

local dinscat =AddNewCatalogue("Duct Insulations", hvaccat);
CatalogueAddType(dinscat, 'DUCT_INSULATION'); 

local applcat =AddNewCatalogue("HVAC Appliances", hvaccat);
CatalogueAddType(applcat, 'HVAC_APPLIANCE','FAN');      
local gappcat =AddNewCatalogue( "Generic HVAC Appliances", applcat);
CatalogueAddType(gappcat , 'HVAC_APPLIANCE');  
local Fancat =AddNewCatalogue( "Fans", applcat);
CatalogueAddType(Fancat , 'FAN'); 
local GCFancat =AddNewCatalogue( "Generic Centrifugal Fans", Fancat);
CatalogueAddType(GCFancat , 'FAN');  

local newprod1= "";

InputClear();
InputAddPoint(0,0,0);
InputAddPoint(1,0,0);

for tag in CreateElement('CIRCULAR_DUCT') do 
       local ele_type = GetElementType(tag);
           if ele_type=="CIRCULAR_DUCT" then  

           SetProperty(tag,'KEYWORD_1','Circular Duct');
           SetProperty(tag,'KEYWORD_2','26 ga');

           for i=4,44,1 do
	   SetProperty(tag,'OUTSIDE_DIAMETER', i*0.0254);
	   SetProperty(tag,'WALL_THICKNESS',0.00107);
	   SetProperty(tag,'NAME',i..' in. Circular Duct');
	   SetProperty(tag,'PART_NUMBER','CIRCULAR_DUCT_'..i);
              newprod1 = ProductCreateFromElement(circat,tag);
          end
      end
end

for tag in CreateElement('RECTANGULAR_DUCT') do 
       local ele_type = GetElementType(tag);
           if ele_type=="RECTANGULAR_DUCT" then  

           SetProperty(tag,'KEYWORD_1','Rectangular Duct');
           SetProperty(tag,'KEYWORD_2','26 ga');

              local rd4cat =AddNewCatalogue("4in Height- Rectangular Ducts", rdcat);
             CatalogueAddType(rd4cat, 'RECTANGULAR_DUCT');  
           for i=6,16,2 do
	   SetProperty(tag,'WIDTH', i*0.0254);
	   SetProperty(tag,'HEIGHT', 4*0.0254);
	   SetProperty(tag,'WALL_THICKNESS',0.00107);
	   SetProperty(tag,'NAME',i..'x 4 in. Rectangular Duct');
	   SetProperty(tag,'PART_NUMBER','RECTANGULAR_DUCT_'..i..'x4'); 
              newprod1 = ProductCreateFromElement(rd4cat,tag);
          end

              local rd6cat =AddNewCatalogue("6in Height- Rectangular Ducts", rdcat);
             CatalogueAddType(rd6cat, 'RECTANGULAR_DUCT');  

          for i=6,30,2 do
	   SetProperty(tag,'WIDTH', i*0.0254);
	   SetProperty(tag,'HEIGHT', 6*0.0254);
	   SetProperty(tag,'WALL_THICKNESS',0.00107);
	   SetProperty(tag,'NAME',i..'x 6 in. Rectangular Duct');
	   SetProperty(tag,'PART_NUMBER','RECTANGULAR_DUCT_'..i..'x6'); 
              newprod1 = ProductCreateFromElement(rd6cat,tag);
          end

              local rd8cat =AddNewCatalogue("8in Height- Rectangular Ducts", rdcat);
             CatalogueAddType(rd8cat, 'RECTANGULAR_DUCT');  

          for i=8,30,2 do
	   SetProperty(tag,'WIDTH', i*0.0254);
	   SetProperty(tag,'HEIGHT', 8*0.0254);
	   SetProperty(tag,'WALL_THICKNESS',0.00107);
	   SetProperty(tag,'NAME',i..'x 8 in. Rectangular Duct');
	   SetProperty(tag,'PART_NUMBER','RECTANGULAR_DUCT_'..i..'x8'); 
              newprod1 = ProductCreateFromElement(rd8cat,tag);
          end

              local rd10cat =AddNewCatalogue("10in Height- Rectangular Ducts", rdcat);
             CatalogueAddType(rd10cat, 'RECTANGULAR_DUCT');  

          for i=10,30,2 do
	   SetProperty(tag,'WIDTH', i*0.0254);
	   SetProperty(tag,'HEIGHT', 10*0.0254);
	   SetProperty(tag,'WALL_THICKNESS',0.00107);
	   SetProperty(tag,'NAME',i..'x 10 in. Rectangular Duct');
	   SetProperty(tag,'PART_NUMBER','RECTANGULAR_DUCT_'..i..'x10'); 
              newprod1 = ProductCreateFromElement(rd10cat,tag);
          end

              local rd12cat =AddNewCatalogue("12in Height- Rectangular Ducts", rdcat);
             CatalogueAddType(rd12cat, 'RECTANGULAR_DUCT');  

          for i=12,24,2 do
	   SetProperty(tag,'WIDTH', i*0.0254);
	   SetProperty(tag,'HEIGHT', 12*0.0254);
	   SetProperty(tag,'WALL_THICKNESS',0.00107);
	   SetProperty(tag,'NAME',i..'x 12 in. Rectangular Duct');
	   SetProperty(tag,'PART_NUMBER','RECTANGULAR_DUCT_'..i..'x12'); 
              newprod1 = ProductCreateFromElement(rd12cat,tag);
          end


      end
end

local DuctInsDesc= GetTypeDescription('DUCT_INSULATION');

local mats = {};

table.insert(mats, "S511");
table.insert(mats, "S420");
table.insert(mats, "S660");
table.insert(mats, "S680");
table.insert(mats, "S690");
table.insert(mats, "S700");


local newprod1= "";
  InputClear();
  InputAddPoint(0,0,0);

  for tag in CreateElement('DUCT_INSULATION')   
        do
             local ele_type = GetElementType(tag);
             if ele_type=="DUCT_INSULATION"  then 
                 SetProperty(tag,'KEYWORD_1',DuctInsDesc);

                 for mati,material in ipairs(mats) do 
                      MaterialClearCollection();
                      MaterialAddtoCollection("insulationMat",material)
                      local matName = MaterialGetProperty("insulationMat",'NAME');
                      SetProperty(tag,'KEYWORD_2',matName);
                      local subcat =AddNewCatalogue( matName.." Duct Insulations", dinscat);
                      CatalogueAddType(subcat , 'DUCT_INSULATION'); 
                      for ii = 1,4,1 do 
                         local insThk = ii/2;
                         SetProperty(tag,'NAME',DuctInsDesc.."- "..matName.."- "..insThk.." in." );
                         SetProperty(tag,'PART_NUMBER','WIG-'.. mati.."-"..ii);
                         SetLayersCount(tag, 1)
                         SetLayerMaterialID(tag,0,material);
                         SetLayerThickness(tag,0,insThk*0.0254);  
                         newprod1 = ProductCreateFromElement(subcat ,tag);
                      end
                 end
             end
  end

  InputClear();
  InputAddPoint(0,0,0);
  for tag in CreateElement('HVAC_APPLIANCE')  do
        local ele_type = GetElementType(tag);
        if ele_type=="HVAC_APPLIANCE" then 
                  SetProperty(tag,'SHAPE',0 ); 
                  SetProperty(tag,'LENGTH',1 ); 
                  SetProperty(tag,'WIDTH',1 ); 
                  SetProperty(tag,'HEIGHT',1 ); 
                  SetProperty(tag,'AIR_FLOW',0.1 );  
                  SetProperty(tag,'NAME','Generic Heater')
                  SetProperty(tag,'APPLIANCE_TYPE','GENERIC_HEATER' ); 
                  SetProperty(tag,'PART_NUMBER','HEATG-001' );

                  SetProperty(tag,'HEATING_CAPACITY',1000 );   
                  SetProperty(tag,'COOLING_CAPACITY',0 );
                  SetProperty(tag,'HUMIDIFICATION_RATE',0 );   
                  local newprod1 = ProductCreateFromElement(gappcat,tag);

                  SetProperty(tag,'NAME','Generic Cooler')
                  SetProperty(tag,'APPLIANCE_TYPE','GENERIC_COOLER' ); 
                  SetProperty(tag,'PART_NUMBER','COOLG-001' );

                  SetProperty(tag,'HEATING_CAPACITY',0 );   
                  SetProperty(tag,'COOLING_CAPACITY',1000 );
                  SetProperty(tag,'HUMIDIFICATION_RATE',0 );   
                  local newprod2 = ProductCreateFromElement(gappcat,tag);

                  SetProperty(tag,'AIR_FLOW',0.1 );  
                  SetProperty(tag,'NAME','Generic Humidifier')
                  SetProperty(tag,'APPLIANCE_TYPE','GENERIC_HUMIDIFIER' ); 
                  SetProperty(tag,'PART_NUMBER','HUMG-001' );

                  SetProperty(tag,'HEATING_CAPACITY',0);   
                  SetProperty(tag,'COOLING_CAPACITY',0 );
                  SetProperty(tag,'HUMIDIFICATION_RATE',0.000001 );   
                  local newprod3 = ProductCreateFromElement(gappcat,tag);

        end
end

for tag in CreateElement('FAN')  do
        local ele_type = GetElementType(tag);
        if ele_type=="FAN" then 
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
           for tag3 in CreateElement('DUCT_FITTING')  do
               local ele_type3 = GetElementType(tag3);
               if ele_type3=="DUCT_FITTING" then 
               inlet_tag=tag3;
               end
            end


           local outlet_tag=""
           for tag4 in CreateElement('DUCT_FITTING')  do
               local ele_type4 = GetElementType(tag4);
               if ele_type4=="DUCT_FITTING" then 
               outlet_tag=tag4;
               end
            end


                  SetProperty(motor_tag,'NAME','Generic Electric Motor')
                  SetProperty(motor_tag,'APPLIANCE_TYPE','GENERIC_ELECTRIC_MOTOR' ); 
                  SetProperty(motor_tag,'SHAPE',0 );
                  SetProperty(motor_tag,'LENGTH',0.3 );
                  SetProperty(motor_tag,'WIDTH',0.5 );
                  SetProperty(motor_tag,'HEIGHT',0.3 );
                  SetProperty(motor_tag,'OFFSET_Z',-0.065 );
                  SetProperty(motor_tag,'CONNECTION_LENGTH' ,0.25 );
                  SetProperty(motor_tag,'VOLTAGE',115 );
                  SetProperty(motor_tag,'CURRENT',7 );
                  SetProperty(motor_tag,'POWER',800 );
                  SetProperty(motor_tag,'PART_NUMBER','GEM-001' );

                SetProperty(inlet_tag,'KEYWORD_1',"Fan inlet");
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
 
                SetProperty(outlet_tag,'KEYWORD_1',"Fan outlet");
                SetProperty(outlet_tag,'MANUFACTURER',"Generic");
                SetProperty(outlet_tag,'FITTING_MATERIAL',"S30");  
                SetProperty(outlet_tag,'NAME',"Generic Fan outlet" );  
                SetProperty(outlet_tag,'KEYWORD_2',"Fan outlet");
                SetProperty(outlet_tag,'AUTOSIZE', false); 
                SetProperty(outlet_tag,'OUTSIDE_DIAMETER', 0.0889);
                SetProperty(outlet_tag,'WALL_THICKNESS', 0.005486); 
                SetProperty(outlet_tag,'CONNECTION_LENGTH', -0.065);
                SetProperty(outlet_tag,'SIDE', 2); 
                SetProperty(outlet_tag,'CONNECTION_ANGLE', 3.927); 
                SetProperty(outlet_tag,'DIRECTION' , 2); 

                SetProperty(tag,'NAME','Generic Centrifugal Fan 10') 
                SetProperty(tag,'APPLIANCE_TYPE','GENERIC_CENTRIFUGAL_FAN' ); 
                SetProperty(tag,'PART_NUMBER','GCF-001' );
                SetProperty(tag,'LENGTH',0.1);
                SetProperty(tag,'DIAMETER',0.449); 
                SetProperty(tag,'STATIC_PRESSURE_FLOW_CURVE_FORMULA',"1595*x+219"); 
                SetProperty(tag,'POWER_FLOW_CURVE_FORMULA',"-5285*x+2177"); 
                SetProperty(tag,'MIN_FLOW',0.05144); 
                SetProperty(tag,'MAX_FLOW',0.335); 
                SetProperty(tag,'MAX_POWER',760); 
                SetProperty(tag,'BODY_MATERIAL',"S30"); 

                local newprod1 = ProductCreateFromElement(GCFancat,tag);
                ActivateProduct(newprod1);

                SetProperty(motor_tag,'LENGTH',0.3 );
                SetProperty(motor_tag,'WIDTH',0.5 );
                SetProperty(motor_tag,'HEIGHT',0.3 );
                SetProperty(motor_tag,'OFFSET_Z',-0.065 );
                SetProperty(motor_tag,'CONNECTION_LENGTH' ,0.25 );
                SetProperty(motor_tag,'VOLTAGE',115 );
                SetProperty(motor_tag,'CURRENT',20 );
                SetProperty(motor_tag,'POWER',2300 );
                SetProperty(motor_tag,'PART_NUMBER','GEM-002' );

                SetProperty(inlet_tag,'OUTSIDE_DIAMETER', 0.168275);
                SetProperty(inlet_tag,'WALL_THICKNESS', 0.007112); 
                SetProperty(inlet_tag,'CONNECTION_LENGTH', 0.04);

                SetProperty(outlet_tag,'OUTSIDE_DIAMETER', 0.1143);
                SetProperty(outlet_tag,'WALL_THICKNESS', 0.00602); 
                SetProperty(outlet_tag,'CONNECTION_LENGTH', -0.065);

                SetProperty(tag,'NAME','Generic Centrifugal Fan 12') 
                SetProperty(tag,'PART_NUMBER','GCF-002' );
                SetProperty(tag,'LENGTH',0.125);
                SetProperty(tag,'DIAMETER',0.449); 
                SetProperty(tag,'STATIC_PRESSURE_FLOW_CURVE_FORMULA',"-5029*x+3842"); 
                SetProperty(tag,'POWER_FLOW_CURVE_FORMULA',"2619*x+371"); 
                SetProperty(tag,'MIN_FLOW',0.357); 
                SetProperty(tag,'MAX_FLOW',0.705); 
                SetProperty(tag,'MAX_POWER',2222); 

                local newprod2 = ProductCreateFromElement(GCFancat,tag);

                SetProperty(motor_tag,'LENGTH',0.3 );
                SetProperty(motor_tag,'WIDTH',0.5 );
                SetProperty(motor_tag,'HEIGHT',0.3 );
                SetProperty(motor_tag,'OFFSET_Z',-0.065 );
                SetProperty(motor_tag,'CONNECTION_LENGTH' ,0.25 );
                SetProperty(motor_tag,'VOLTAGE',115 );
                SetProperty(motor_tag,'CURRENT',35 );
                SetProperty(motor_tag,'POWER',4000 );
                SetProperty(motor_tag,'PART_NUMBER','GEM-003' );

                SetProperty(inlet_tag,'OUTSIDE_DIAMETER', 0.219075);
                SetProperty(inlet_tag,'WALL_THICKNESS', 0.008179); 
                SetProperty(inlet_tag,'CONNECTION_LENGTH', 0.042);

                SetProperty(outlet_tag,'OUTSIDE_DIAMETER', 0.168275);
                SetProperty(outlet_tag,'WALL_THICKNESS', 0.007112); 
                SetProperty(outlet_tag,'CONNECTION_LENGTH', -0.065);

                SetProperty(tag,'NAME','Generic Centrifugal Fan 14') 
                SetProperty(tag,'PART_NUMBER','GCF-003' );
                SetProperty(tag,'LENGTH',0.221);
                SetProperty(tag,'DIAMETER',0.56); 
                SetProperty(tag,'STATIC_PRESSURE_FLOW_CURVE_FORMULA',"-6894*x+6130"); 
                SetProperty(tag,'POWER_FLOW_CURVE_FORMULA',"3955*x+607"); 
                SetProperty(tag,'MIN_FLOW',0.595); 
                SetProperty(tag,'MAX_FLOW',0.847); 
                SetProperty(tag,'MAX_POWER',3944); 

                local newprod3 = ProductCreateFromElement(GCFancat,tag);

        end
end

CatalogueSave( hvaccat, "HVAC catalogue");

ListCatalogues();
