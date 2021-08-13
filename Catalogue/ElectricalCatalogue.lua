CatalogueClearAll();

CreateNewMetricProject();

local electcat =AddNewCatalogue("Electrical", "");
CatalogueAddType(electcat,'ELECTRICAL_JOINT','WIRE','WIRE_INSULATION','CABLE','ELECTRICAL_CONDUIT', 'ELECTRIC_APPLIANCE','ELECTRIC_LIGHT'); 

local waccat =AddNewCatalogue("Wires and Cables",  electcat );
CatalogueAddType(waccat , 'ELECTRICAL_JOINT','WIRE','WIRE_INSULATION','CABLE','ELECTRICAL_CONDUIT'); 

local elccat =AddNewCatalogue("Electrical Connections", waccat );
CatalogueAddType(elccat, 'ELECTRICAL_JOINT'); 
 
local wijcat =AddNewCatalogue( " Wire Joints", elccat);
CatalogueAddType(wijcat , 'ELECTRICAL_JOINT'); 

local wirecat =AddNewCatalogue("Wires", waccat);
CatalogueAddType( wirecat, 'WIRE'); 

local winscat =AddNewCatalogue("Wire Insulations", waccat);
CatalogueAddType(winscat, 'WIRE_INSULATION'); 

local cabcat =AddNewCatalogue("Cables", waccat);
CatalogueAddType(cabcat, 'CABLE'); 

local eleconcat =AddNewCatalogue("Electrical Conduits", waccat);
CatalogueAddType(eleconcat, 'ELECTRICAL_CONDUIT');  

local theccat =AddNewCatalogue("Thin-Wall Electrical Conduits", eleconcat);
CatalogueAddType(theccat, 'ELECTRICAL_CONDUIT');  

local eapcat =AddNewCatalogue("Electric Appliances", electcat );
CatalogueAddType(eapcat, 'ELECTRIC_APPLIANCE','ELECTRIC_LIGHT');     

local geacat =AddNewCatalogue( "Generic Electric Appliances", eapcat);
CatalogueAddType(geacat , 'ELECTRIC_APPLIANCE');  

local elicat =AddNewCatalogue("Electric Lights", eapcat);
CatalogueAddType(elicat, 'ELECTRIC_LIGHT');  

local elisubcat =AddNewCatalogue( "Lights", elicat);
CatalogueAddType(elisubcat , 'ELECTRIC_LIGHT'); 

local reclight =AddNewCatalogue( "Rectangular Lights", elisubcat);
CatalogueAddType(reclight , 'ELECTRIC_LIGHT'); 

local vcyllight =AddNewCatalogue( "Vertical Cylindrical Lights", elisubcat);
CatalogueAddType(vcyllight , 'ELECTRIC_LIGHT'); 

local hcyllight =AddNewCatalogue( "Horizontal Cylindrical Lights", elisubcat);
CatalogueAddType(hcyllight , 'ELECTRIC_LIGHT'); 

local sphlight =AddNewCatalogue( "Spherical Lights", elisubcat);
CatalogueAddType( sphlight , 'ELECTRIC_LIGHT'); 

local mats = {};

  InputClear();
  InputAddPoint(0,0,0);
  for tag in CreateElement('ELECTRICAL_JOINT')  do
        local ele_type = GetElementType(tag);
        if ele_type=="ELECTRICAL_JOINT" then 
                  SetProperty(tag,'NAME','Wire Joint')
                  SetProperty(tag,'ELECTRICAL_JOINT_TYPE',0)
                  SetProperty(tag,'AUTOSIZE', false) 
                  SetProperty(tag,'OUTSIDE_DIAMETER',0.05)
                  SetProperty(tag,'WALL_THICKNESS' ,0.001)
                  SetProperty(tag,'AUTOSIZE', true) 
                  SetProperty(tag,'PART_NUMBER','WJ-001' );
                  local newprod1 = ProductCreateFromElement(wijcat,tag);
        end
end


local wireInsDesc= GetTypeDescription('WIRE_INSULATION');

local mats = {};

table.insert(mats, "S671");
table.insert(mats, "S710");
table.insert(mats, "S740");
table.insert(mats, "S741");
table.insert(mats, "S750");
table.insert(mats, "S780");
table.insert(mats, "S800");
table.insert(mats, "S801");
table.insert(mats, "S675");



local newprod1= "";
  InputClear();
  InputAddPoint(0,0,0);

  for tag in CreateElement('WIRE_INSULATION')   
        do
             local ele_type = GetElementType(tag);
             if ele_type=="WIRE_INSULATION"  then 
                 SetProperty(tag,'KEYWORD_1',wireInsDesc);

                 for mati,material in ipairs(mats) do 
                      MaterialClearCollection();
                      MaterialAddtoCollection("insulationMat",material)
                      local matName = MaterialGetProperty("insulationMat",'NAME');
                      SetProperty(tag,'KEYWORD_2',matName);
                      local winssubcat =AddNewCatalogue( matName.." Wire Insulations", winscat);
                      CatalogueAddType(winssubcat , 'WIRE_INSULATION'); 
                      for ii = 1,10,1 do 
                         local insThk = ii/64;
                         SetProperty(tag,'NAME',wireInsDesc.."- "..matName.."- "..insThk.." in." );
                         SetProperty(tag,'PART_NUMBER','WIG-'.. mati.."-"..ii);
                         SetLayersCount(tag, 1)
                         SetLayerMaterialID(tag,0,material);
                         SetLayerThickness(tag,0,insThk*0.0254);  
                         newprod1 = ProductCreateFromElement(winssubcat ,tag);
                      end
                 end
             end
   end

local mats = {};
table.insert(mats, "S90");
table.insert(mats, "S170");

local newprod1= "";
local wireGauges = GetWireGauges();
  InputClear();
  InputAddPoint(0,0,0);
  InputAddPoint(1,0,0);
  for tag in CreateElement('WIRE') 
        do
             local ele_type = GetElementType(tag);
             if ele_type=="WIRE" then 
                for mati,material in ipairs(mats) do 

                      MaterialClearCollection();
                      MaterialAddtoCollection("WireMat",material)
                      local matName = MaterialGetProperty("WireMat",'NAME'); 
                      SetProperty(tag,'KEYWORD_2',matName);
                      SetProperty(tag,'CORE_MATERIAL',material );
                      local wiresubcat =AddNewCatalogue( matName.." Wires", wirecat);
                      CatalogueAddType(wiresubcat  , 'WIRE'); 
                      local gindex = 0;
                     for gi,gv in ipairs(wireGauges ) do 
                               local AWGname = gv[1];
                               local AWGdia = gv[2];
                               SetProperty(tag,'NAME',GetTypeDescription('WIRE')..'- '.. matName.."- "..AWGname );
                               SetProperty(tag,'PART_NUMBER','Wire '..AWGname );
                               SetProperty(tag,'WIRE_GAUGE' ,gindex );
                               gindex = gindex+1;
                               newprod1 = ProductCreateFromElement(wiresubcat ,tag);
                     end 
             end
   end
end

local newprod1= "";

InputClear();
InputAddPoint(0,0,0);
InputAddPoint(1,0,0);

for tag in CreateElement('CABLE') do
       local ele_type = GetElementType(tag);
       if ele_type=="CABLE" then 

             SetProperty(tag,'KEYWORD_1','Electrical Cable');
             for i=2,10,1 do
                      SetProperty(tag,'CORES_COUNT',i);
                      SetProperty(tag,'OUTSIDE_DIAMETER',i*0.005);  
                      SetProperty(tag,'KEYWORD_2',i..' Cores');
                      SetProperty(tag,'NAME',i..' Cores Cable' );
                      SetProperty(tag,'PART_NUMBER','CABLE'..i );
                      RefreshElement(tag);
                      newprod1 = ProductCreateFromElement(cabcat,tag);
            end
      end
end

local newprod1= "";

InputClear();
InputAddPoint(0,0,0);
InputAddPoint(1,0,0);

for tag in CreateElement('ELECTRICAL_CONDUIT') do 
       local ele_type = GetElementType(tag);
           if ele_type=="ELECTRICAL_CONDUIT" then  

           SetProperty(tag,'KEYWORD_1','Electrical Conduit');
           SetProperty(tag,'KEYWORD_2','thin-wall');

	SetProperty(tag,'OUTSIDE_DIAMETER',0.0179);
	SetProperty(tag,'WALL_THICKNESS',0.00107);
	SetProperty(tag,'NAME','1/2in in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT16EMT');
           newprod1 = ProductCreateFromElement(theccat,tag);

	SetProperty(tag,'OUTSIDE_DIAMETER',0.0234);
	SetProperty(tag,'WALL_THICKNESS',0.00125);
	SetProperty(tag,'NAME','3/4in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT21EMT');
           newprod1 = ProductCreateFromElement(theccat,tag);

          	SetProperty(tag,'OUTSIDE_DIAMETER',0.0295);
	SetProperty(tag,'WALL_THICKNESS',0.00145);
	SetProperty(tag,'NAME','1in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT27EMT');
	newprod1 = ProductCreateFromElement(theccat,tag);

	SetProperty(tag,'OUTSIDE_DIAMETER',0.0384);
	SetProperty(tag,'WALL_THICKNESS',0.00165);
	SetProperty(tag,'NAME','1 1/4in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT35EMT');
	newprod1 = ProductCreateFromElement(theccat,tag);

	SetProperty(tag,'OUTSIDE_DIAMETER',0.0442);
	SetProperty(tag,'WALL_THICKNESS',0.00165);
	SetProperty(tag,'NAME','1 1/2in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT41EMT');
	newprod1 = ProductCreateFromElement(theccat,tag);

	SetProperty(tag,'OUTSIDE_DIAMETER',0.0558);
	SetProperty(tag,'WALL_THICKNESS',0.00165);
	SetProperty(tag,'NAME','2in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT53EMT');
	newprod1 = ProductCreateFromElement(theccat,tag);

	SetProperty(tag,'OUTSIDE_DIAMETER',0.073);
	SetProperty(tag,'WALL_THICKNESS',0.00183);
	SetProperty(tag,'NAME','2 1/2in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT63EMT');
	newprod1 = ProductCreateFromElement(theccat,tag);

	SetProperty(tag,'OUTSIDE_DIAMETER',0.0889);
	SetProperty(tag,'WALL_THICKNESS',0.00183);
	SetProperty(tag,'NAME','3in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT78EMT');
	newprod1 = ProductCreateFromElement(theccat,tag);

	SetProperty(tag,'OUTSIDE_DIAMETER',0.1016);
	SetProperty(tag,'WALL_THICKNESS',0.00211);
	SetProperty(tag,'NAME','3 1/2in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT91EMT');
	newprod1 = ProductCreateFromElement(theccat,tag);

	SetProperty(tag,'OUTSIDE_DIAMETER',0.1143);
	SetProperty(tag,'WALL_THICKNESS',0.00211);
	SetProperty(tag,'NAME','4in. thin-wall Electrical conduit');
	SetProperty(tag,'PART_NUMBER','EL_CONDUIT103EMT');
	newprod1 = ProductCreateFromElement(theccat,tag);

      end
end

local mats = {};

  InputClear();
  InputAddPoint(0,0,0);
  for tag in CreateElement('ELECTRIC_APPLIANCE')  do
        local ele_type = GetElementType(tag);
        if ele_type=="ELECTRIC_APPLIANCE" then 

                  SetProperty(tag,'LENGTH',0.75 );
                  SetProperty(tag,'WIDTH',0.75 );
                  SetProperty(tag,'HEIGHT',0.75 );

                  SetProperty(tag,'NAME','Generic Rectangular Electric Appliance') 
                  SetProperty(tag,'APPLIANCE_TYPE','GENERIC_ELECTRIC_APPLIANCE' ); 
                  SetProperty(tag,'PART_NUMBER','EAG-001' );
                  SetProperty(tag,'SHAPE',0 );
                  local newprod1 = ProductCreateFromElement(geacat,tag);

                  SetProperty(tag,'NAME','Generic Vertical Cylindrical Electric Appliance') 
                  SetProperty(tag,'PART_NUMBER','EAG-002' );
                  SetProperty(tag,'SHAPE',1 );
                  SetProperty(tag,'DIAMETER',0.75 );
                  local newprod1 = ProductCreateFromElement(geacat,tag);

                  SetProperty(tag,'NAME','Generic Horizontal Cylindrical Electric Appliance') 
                  SetProperty(tag,'PART_NUMBER','EAG-003' );
                  SetProperty(tag,'SHAPE',2 );
                  local newprod1 = ProductCreateFromElement(geacat,tag);

                  SetProperty(tag,'NAME','Generic Spherical Electric Appliance') 
                  SetProperty(tag,'PART_NUMBER','EAG-004' );
                  SetProperty(tag,'SHAPE',3 );
                  local newprod1 = ProductCreateFromElement(geacat,tag);
        end
end

local mats = {};

  InputClear();
  InputAddPoint(0,0,0);
  for tag in CreateElement('ELECTRIC_LIGHT')  do
        local ele_type = GetElementType(tag);
        if ele_type=="ELECTRIC_LIGHT" then 
                  SetProperty(tag,'LIGHT_TYPE',2)
                  SetProperty(tag,'APPLIANCE_TYPE','GENERIC_LIGHT' ); 
                  SetProperty(tag,'LIGHT_SHAPE',1) 

                  SetProperty(tag,'NAME','Rectangular Electric Light, 5 cm x 5 cm x 2 cm')
                  SetProperty(tag,'SHAPE',0)  

                  SetProperty(tag,'LENGTH',0.05) 
                  SetProperty(tag,'WIDTH',0.05)  
                  SetProperty(tag,'HEIGHT',0.02)  
                  SetProperty(tag,'PART_NUMBER','ELR-001' );

                  local newprodr0 = ProductCreateFromElement(reclight,tag);

                  SetProperty(tag,'NAME','Rectangular Electric Light, 10 cm x 10 cm x 5 cm')
                  SetProperty(tag,'LENGTH',0.1) 
                  SetProperty(tag,'WIDTH',0.1)  
                  SetProperty(tag,'HEIGHT',0.05)  
                  SetProperty(tag,'PART_NUMBER','ELR-002' );

                  local newprodr1 = ProductCreateFromElement(reclight,tag);

                  SetProperty(tag,'NAME','Vertical Cylindrical Electric Light, 10 cm dia. x 5 cm')
                  SetProperty(tag,'SHAPE',1)  

                  SetProperty(tag,'DIAMETER',0.1)
                  SetProperty(tag,'HEIGHT',0.05)  
                  SetProperty(tag,'PART_NUMBER','ELCV-001' );

                  local newprodvc0 = ProductCreateFromElement(vcyllight,tag);

                  SetProperty(tag,'NAME','Vertical Cylindrical Electric Light, 20 cm dia. x 10 cm H')
                  SetProperty(tag,'DIAMETER',0.2)
                  SetProperty(tag,'HEIGHT',0.1)  
                  SetProperty(tag,'PART_NUMBER','ELCV-002' );

                  local newprodvc1 = ProductCreateFromElement(vcyllight,tag);

                  SetProperty(tag,'SHAPE',2)  


                  SetProperty(tag,'NAME','Horizontal Cylindrical Electric Light, 10 cm dia. x 5 cm L')
                  SetProperty(tag,'DIAMETER',0.1)
                  SetProperty(tag,'LENGTH',0.05)  
                  SetProperty(tag,'PART_NUMBER','ELCH-001' );

                  local newprodhc0 = ProductCreateFromElement(hcyllight,tag);

                  SetProperty(tag,'NAME','Horizontal Cylindrical Electric Light, 20 cm dia. x 10 cm L')
                  SetProperty(tag,'DIAMETER',0.2)
                  SetProperty(tag,'LENGTH',0.1)  
                  SetProperty(tag,'PART_NUMBER','ELCH-002' );

                  local newprodhc1 = ProductCreateFromElement(hcyllight,tag);

                  SetProperty(tag,'SHAPE',3)  

                  SetProperty(tag,'NAME','Spherical Electric Light, 5 cm dia.')
                  SetProperty(tag,'DIAMETER',0.05)
                  SetProperty(tag,'PART_NUMBER','ELSP-001' );

                  local newprodsp2 = ProductCreateFromElement(sphlight ,tag);
                  SetProperty(tag,'NAME','Spherical Electric Light, 10 cm dia.')
                  SetProperty(tag,'DIAMETER',0.1)
                  SetProperty(tag,'PART_NUMBER','ELSP-002' );

                  local newprodsp1 = ProductCreateFromElement(sphlight ,tag);

        end
end
CatalogueSave( electcat, "Electrical catalogue");
ListCatalogues();
