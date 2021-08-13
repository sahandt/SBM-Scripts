CatalogueClearAll();

CreateNewMetricProject();

local strcat =AddNewCatalogue("Structural", "");
CatalogueAddType(strcat, 'FLOOR','SQCOLUMN', 'RNDCOLUMN', 'WINDOW', 'DOOR', 'WALL' ,'FURNITURE','FIXTURE' ); 

local floorcat =AddNewCatalogue("Floors",strcat);
CatalogueAddType(floorcat, 'FLOOR'); 

local wallcat =AddNewCatalogue("Walls",strcat);
CatalogueAddType(wallcat, 'WALL'); 

 local colcat =AddNewCatalogue("Columns", strcat);
 CatalogueAddType( colcat , 'SQCOLUMN', 'RNDCOLUMN'); 

 local scolcat =AddNewCatalogue("Square Columns",colcat );
 CatalogueAddType( scolcat , 'SQCOLUMN'); 

 local rcolcat =AddNewCatalogue("Round Columns",colcat );
 CatalogueAddType( rcolcat , 'RNDCOLUMN'); 

local wincat =AddNewCatalogue("Windows",strcat);
CatalogueAddType(wincat, 'WINDOW'); 

local wincat1 =AddNewCatalogue("Generic Windows,Low Profile Glazing, Wooden Frame",wincat);
CatalogueAddType(wincat1, 'WINDOW'); 

local wincat2 =AddNewCatalogue("Generic Windows,High Profile Glazing, Wooden Frame",wincat);
CatalogueAddType(wincat2, 'WINDOW'); 

local wincat3 =AddNewCatalogue("Generic Windows,Low Profile Glazing, Aluminum Frame",wincat);
CatalogueAddType(wincat3, 'WINDOW'); 

local wincat4 =AddNewCatalogue("Generic Windows,High Profile Glazing, Aluminum Frame",wincat);
CatalogueAddType(wincat4, 'WINDOW'); 

local doorcat =AddNewCatalogue("Doors",strcat);
CatalogueAddType(doorcat, 'DOOR'); 

local doorcat1 =AddNewCatalogue("Generic Doors, Wooden panel, No glazing",doorcat);
CatalogueAddType(doorcat1, 'DOOR'); 

local doorcat2 =AddNewCatalogue("Generic Doors, Aluminum panel with glazing",doorcat);
CatalogueAddType(doorcat2, 'DOOR'); 

local Furncat =AddNewCatalogue("Furnitures",strcat);
CatalogueAddType(Furncat, 'FURNITURE'); 

local GFurncat =AddNewCatalogue("Generic Furnitures",Furncat);
CatalogueAddType(GFurncat, 'FURNITURE'); 

local Fixtcat =AddNewCatalogue("Fixtures",strcat);
CatalogueAddType(Fixtcat, 'FIXTURE'); 

local GFixtcat  =AddNewCatalogue("Generic Fixtures",Fixtcat );
CatalogueAddType(GFixtcat, 'FIXTURE'); 

MaterialClearCollection();
MaterialAddtoCollection("CarbonSteel","S30")
local matName = MaterialGetProperty("CarbonSteel",'NAME'); 

MaterialAddtoCollection("Copper","S90")
local cmatName = MaterialGetProperty("Copper",'NAME'); 

MaterialAddtoCollection("GMW","S510")
local gmwmatName = MaterialGetProperty("GMW",'NAME'); 

MaterialAddtoCollection("Concrete","S590")
local ConcMatName = MaterialGetProperty("Concrete",'NAME'); 

MaterialAddtoCollection("GypsumBoard","S440")
local GBMatName = MaterialGetProperty("GypsumBoard",'NAME'); 

MaterialAddtoCollection("S560")
local WDMatName = MaterialGetProperty("S560",'NAME'); 

MaterialAddtoCollection("S500")
local GlsMatName = MaterialGetProperty("S500",'NAME'); 

MaterialAddtoCollection("S170")
local AlumMatName = MaterialGetProperty("S170",'NAME'); 

local floor1;
local floor2;
local wall1;

InputClear();
InputAddPoint(0,0,0);

local newprod;

for tag in CreateElement('BUILDING')  do end    

for tag in CreateElement('FLOOR')  do
            if(GetElementType(tag)=='FLOOR') then
                      floor1= tag;
                      SetProperty(tag,'MANUFACTURER',"Generic");
                      SetProperty(tag,'KEYWORD_1','Floor');
                      SetProperty(tag,'KEYWORD_2',"Concrete");
                      for thickness=4,12,1 do
                          SetProperty(tag,'NAME',"Generic Concrete Floor, "..thickness.. " inches thick" );
                          SetLayersCount(tag, 1)
                          SetLayerMaterialID(tag,0,"S590");
                          SetLayerThickness(tag,0,thickness* 25.4 / 1000);  
                          newprod = ProductCreateFromElement(floorcat  ,tag);
                      end
                      ActivateProduct(newprod);
       end
 end    

for tag in CreateElement('FLOOR')  do
     if(GetElementType(tag)=='FLOOR') then
                      floor2= tag;
     end
end 

InputAddElement(floor1)
InputAddElement(floor2)

local col1
local col2

InputAddEnterKey() 

for tag in CreateElement('RNDCOLUMN')  do
     if(GetElementType(tag)=='RNDCOLUMN') then
                      col1 = tag;
                      SetProperty(tag,'MANUFACTURER',"Generic");
                      SetProperty(tag,'KEYWORD_1','Round Column');
                      SetProperty(tag,'KEYWORD_2',"Concrete");
                      SetProperty(tag,'BUILDING_COLUMN_MATERIAL',"S590"); 

                      for diameter=0.05,0.5,0.05 do
                      SetProperty(tag,'NAME',"Generic Round Column, "..ConcMatName..", ".. diameter.."m OD" );
                      SetProperty(tag,'OUTSIDE_DIAM',diameter); 
                          newprod = ProductCreateFromElement( rcolcat ,tag);
                      end
                      ActivateProduct(newprod);
    end
 end 

for tag in CreateElement('SQCOLUMN')  do
     if(GetElementType(tag)=='SQCOLUMN') then
                      col2 = tag;
                      SetProperty(tag,'MANUFACTURER',"Generic");
                      SetProperty(tag,'KEYWORD_1','Square Column');
                      SetProperty(tag,'KEYWORD_2',"Concrete");
                      SetProperty(tag,'BUILDING_COLUMN_MATERIAL',"S590"); 

                      for width=0.05,0.5,0.05 do
                          SetProperty(tag,'NAME',"Generic Square Column, "..ConcMatName..", ".. width.." x " ..width.."m" );
                          SetProperty(tag,'WIDTH',width); 
                          newprod = ProductCreateFromElement( scolcat ,tag);
                      end
                      ActivateProduct(newprod);
    end
end 

             InputClear()
             InputAddElement(floor1)
             InputAddElement(floor2)
             InputAddElement(col1)
             InputAddElement(col2)

for tag in CreateElement('WALL')  do
            if(GetElementType(tag)=='WALL') then
                      wall1= tag;
                      SetProperty(tag,'MANUFACTURER',"Generic");
                      SetProperty(tag,'KEYWORD_1','Wall');
                      SetProperty(tag,'KEYWORD_2',"Concrete");
                      for thickness=4,12,1 do
                          SetProperty(tag,'NAME',"Genneric wall, "..thickness.. " inches thick" );
                          SetLayersCount(tag, 3)
                          SetLayerMaterialID(tag,0,"S440");
                          SetLayerThickness(tag,0,0.5 * 0.0254);  

                          SetLayerMaterialID(tag,1,"S590");
                          SetLayerThickness(tag,1,thickness* 25.4 / 1000);  

                          SetLayerMaterialID(tag,2,"S440");
                          SetLayerThickness(tag,2,0.5 * 0.0254);  

                          newprod = ProductCreateFromElement(wallcat  ,tag);
                      end
                      ActivateProduct(newprod);
       end
 end    

function Generate_Window_Product(tagwi,  frame_material,  glazing_material, a,r,g,b,  frame_width_inch,  frame_height_inch, window_width_inch, window_height_inch, window_thickness_inch, cat)

          SetLayersCount(tagwi, 1,1)
          SetLayerMaterialID(tagwi,0,frame_material,1);
          SetLayerThickness(tagwi,0,window_thickness_inch * 0.0254,1);  
          SetFillColor(tagwi,a,r,g,b);
          SetLayersCount(tagwi, 1,2)
          SetLayerMaterialID(tagwi,1,glazing_material,2);
          SetLayerThickness(tagwi,1,window_thickness_inch * 0.0254,2);  

          SetProperty(tagwi,"FRAME_WIDTH",frame_width_inch* 0.0254)
          SetProperty(tagwi,'FRAME_HEIGHT',frame_height_inch* 0.0254)

          SetProperty(tagwi,"WINDOW_WIDTH",window_width_inch* 0.0254) 
          SetProperty(tagwi,'WINDOW_HEIGHT',window_height_inch* 0.0254) 

          SetProperty(tagwi,'NAME',"Generic Window, "..MaterialGetProperty(frame_material,'NAME').." Frame, "..window_width_inch.."x"..window_height_inch);
          SetProperty(tagwi,'MANUFACTURER',"Generic");
          SetProperty(tagwi,'KEYWORD_1','Window');
          SetProperty(tagwi,'KEYWORD_2',MaterialGetProperty(frame_material,'NAME'));
  
          newprodwi = ProductCreateFromElement(cat  ,tagwi); 
end 

InputClear()
InputAddElement(wall1)

for tagwi in CreateElement('WINDOW') do

               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 24,12,21,9.125,0.09375, wincat1);
               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 24, 24, 21, 21.125, 0.09375,wincat1);
               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 24, 48, 21, 45.125, 0.09375,wincat1);
               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 48, 48, 45, 45.125, 0.09375,wincat1);
               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 72, 48, 69, 45.125, 0.09375,wincat1);

               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 24, 12, 18.0625, 6.0625, 0.09375,wincat2);
               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 24, 24, 18.0625, 18.0625, 0.09375,wincat2);
               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 24, 48, 18.0625, 42.0625, 0.09375,wincat2);
               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 48, 48, 42.0625, 42.0625, 0.09375,wincat2);
               Generate_Window_Product(tagwi,"S560", "S500", 255,122,106,69, 72, 48, 66.0625, 42.0625, 0.09375,wincat2);

         Generate_Window_Product(tagwi,"S170", "S500", 255,167, 181, 181, 24, 12, 21, 9.125, 0.09375,wincat3);
         Generate_Window_Product(tagwi,"S170", "S500", 255,167, 181, 181, 24, 24, 21, 21.125, 0.09375,wincat3);
         Generate_Window_Product(tagwi,"S170", "S500", 255,167, 181, 181, 24, 48, 21, 45.125, 0.09375,wincat3);
         Generate_Window_Product(tagwi,"S170", "S500", 255,167, 181, 181, 48, 48, 45, 45.125, 0.09375,wincat3);
         Generate_Window_Product(tagwi,"S170", "S500", 255,167, 181, 181, 72, 48, 69, 45.125, 0.09375,wincat3);

        Generate_Window_Product(tagwi,"S170", "S500", 255,255,101,71, 24, 12, 18.0625, 6.0625, 0.09375,  wincat4);
        Generate_Window_Product(tagwi,"S170", "S500", 255,255,101,71, 24, 24, 18.0625, 18.0625, 0.09375, wincat4);
        Generate_Window_Product(tagwi,"S170", "S500", 255,255,101,71, 24, 48, 18.0625, 42.0625, 0.09375, wincat4);
        Generate_Window_Product(tagwi,"S170", "S500", 255,255,101,71, 48, 48, 42.0625, 42.0625, 0.09375, wincat4);
        Generate_Window_Product(tagwi,"S170", "S500", 255,255,101,71, 72, 48, 66.0625, 42.0625, 0.09375, wincat4);
end

function Generate_Door_Product(tagdr, body_material , a,r,g,b, frame_width_inch , frame_height_inch, door_width_inch, door_height_inch, door_thickness_inch, has_glazing , glazing_width_inch , glazing_height_inch ,glazing_v_offset_inch,drcat )


          SetProperty(tagdr,"NAME", "Generic Door, "..MaterialGetProperty(body_material,'NAME')..", "..door_width_inch.."x"..door_height_inch);
          SetProperty(tagdr,'MANUFACTURER',"Generic");
          SetProperty(tagdr,'KEYWORD_1','Door');
          SetProperty(tagdr,'KEYWORD_2',MaterialGetProperty(body_material,'NAME'));

          SetProperty(tagdr,"HAS_GLAZING", has_glazing);
          SetProperty(tagdr,"FRAME_WIDTH", frame_width_inch* 0.0254); 
          SetProperty(tagdr,"FRAME_HEIGHT", frame_height_inch* 0.0254); 
          SetProperty(tagdr,"DOOR_WIDTH", door_width_inch* 0.0254); 
          SetProperty(tagdr,"DOOR_HEIGHT",door_height_inch* 0.0254); 

          SetFillColor(tagdr,a,r,g,b);

          SetLayersCount(tagdr, 1,1)
          SetLayerMaterialID(tagdr,0,body_material,1);
          SetLayerThickness(tagdr,0,door_thickness_inch * 0.0254,1);  
          SetFillColor(tagdr,a,r,g,b);

          if (has_glazing) then
             SetProperty(tagdr,"GLAZING_WIDTH",glazing_width_inch* 0.0254); 
             SetProperty(tagdr,"GLAZING_HEIGHT",glazing_height_inch* 0.0254); 
             SetProperty(tagdr,"GLAZING_VERTICAL_OFFSET",glazing_v_offset_inch* 0.0254); 
          end
          newprodwi = ProductCreateFromElement(drcat  ,tagdr); 

end

for tagdr in CreateElement('DOOR') do

            Generate_Door_Product(tagdr,"S560", 255,163,113,73, 32.25,82,30,80,1.75,false, 0,0,0, doorcat1);
            Generate_Door_Product(tagdr,"S560", 255,163,113,73, 34.25, 82, 32, 80, 1.75,false, 0,0,0, doorcat1);
            Generate_Door_Product(tagdr,"S560", 255,163,113,73, 34.25, 98, 32, 96, 1.75,false, 0,0,0, doorcat1);
            Generate_Door_Product(tagdr,"S560", 255,163,113,73, 38.25, 82, 36, 80, 1.75,false, 0,0,0, doorcat1);
            Generate_Door_Product(tagdr,"S560", 255,163,113,73, 38.25, 98, 36, 96, 1.75,false, 0,0,0, doorcat1);

            Generate_Door_Product(tagdr,"S170", 255,167,181,181, 32.25, 82, 30, 80, 1.75,true,26,38,19,doorcat2);
            Generate_Door_Product(tagdr,"S170", 255,167,181,181, 34.25, 82, 32, 80, 1.75, true, 28, 38, 19,doorcat2);
            Generate_Door_Product(tagdr,"S170", 255,167,181,181, 34.25, 98, 32, 96, 1.75, true, 28, 46, 23,doorcat2);
            Generate_Door_Product(tagdr,"S170",255,167,181,181, 38.25, 82, 36, 80, 1.75, true, 28, 38, 19,doorcat2);
            Generate_Door_Product(tagdr,"S170", 255,167,181,181, 38.25, 98, 36, 96, 1.75, true, 28, 46, 23,doorcat2);
end

for tag in CreateElement('FURNITURE')  do
        local ele_type = GetElementType(tag);
        if ele_type=="FURNITURE" then 

                  SetProperty(tag,'APPLIANCE_TYPE','GENERIC_FURNITURE' ); 

                  SetProperty(tag,'LENGTH',0.75 );
                  SetProperty(tag,'WIDTH',0.75 );
                  SetProperty(tag,'HEIGHT',0.75 );

                  SetProperty(tag,'NAME','Generic Rectangular Furniture') 
                  SetProperty(tag,'PART_NUMBER','GFUR-001' );
                  SetProperty(tag,'SHAPE',0 );
                  local newprod1 = ProductCreateFromElement(GFurncat,tag);

                  SetProperty(tag,'NAME','Generic Vertical Cylindrical Furniture') 
                  SetProperty(tag,'PART_NUMBER','GFUR-002' );
                  SetProperty(tag,'SHAPE',1 );
                  SetProperty(tag,'DIAMETER',0.75 );
                  local newprod1 = ProductCreateFromElement(GFurncat,tag);

                  SetProperty(tag,'NAME','Generic Horizontal Cylindrical Furniture') 
                  SetProperty(tag,'PART_NUMBER','GFUR-003' );
                  SetProperty(tag,'SHAPE',2 );
                  local newprod1 = ProductCreateFromElement(GFurncat,tag);

                  SetProperty(tag,'NAME','Generic Spherical Furniture') 
                  SetProperty(tag,'PART_NUMBER','GFUR-004' );
                  SetProperty(tag,'SHAPE',3 );
                  local newprod1 = ProductCreateFromElement(GFurncat,tag);

        end
end


for tag in CreateElement('FIXTURE')  do
        local ele_type = GetElementType(tag);
        if ele_type=="FIXTURE" then 

                  SetProperty(tag,'APPLIANCE_TYPE','GENERIC_FIXTURE' ); 

                  SetProperty(tag,'LENGTH',0.1 );
                  SetProperty(tag,'WIDTH',0.1 );
                  SetProperty(tag,'HEIGHT',0.1 );

                  SetProperty(tag,'NAME','Generic Rectangular Fixture') 
                  SetProperty(tag,'PART_NUMBER','GFIX-001' );
                  SetProperty(tag,'SHAPE',0 );
                  local newprod1 = ProductCreateFromElement(GFixtcat,tag);

                  SetProperty(tag,'NAME','Generic Vertical Cylindrical Fixture') 
                  SetProperty(tag,'PART_NUMBER','GFIX-002' );
                  SetProperty(tag,'SHAPE',1 );
                  SetProperty(tag,'DIAMETER',0.1 );
                  local newprod1 = ProductCreateFromElement(GFixtcat,tag);

                  SetProperty(tag,'NAME','Generic Horizontal Cylindrical Fixture') 
                  SetProperty(tag,'PART_NUMBER','GFIX-003' );
                  SetProperty(tag,'SHAPE',2 );
                  local newprod1 = ProductCreateFromElement(GFixtcat,tag);

                  SetProperty(tag,'NAME','Generic Spherical Fixture') 
                  SetProperty(tag,'PART_NUMBER','GFIX-004' );
                  SetProperty(tag,'SHAPE',3 );
                  local newprod1 = ProductCreateFromElement(GFixtcat,tag);

        end
end

CatalogueSave( strcat, "Structural catalogue");

ListCatalogues();
