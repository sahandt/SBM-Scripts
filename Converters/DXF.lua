--[[This script converts current project model to a DXF file and saves the file in DXF directory inside working folder]]
CanvasClearLayers()
SetCanvasSize(30,30) 
CanvasAddLayer("SBM") 
SetLayerLineWeight("SBM", 10)
AddDrawing("Convert")

local now = GetDateTimeNow("yy mm dd hh mm")

CheckDuplicate(true)
local ele_tbl= GetAllElements()
local tag = ""
local type= ""
local xp = 0
local yp = 0
local zp =0

for i,ele in ipairs(ele_tbl) do
      for j,props in ipairs(ele) do
           if props[1]=="Type" then
             type = props[2]
           elseif props[1]=="Tag" then
             tag = props[2]
           elseif props[1]=="PosX" then
              xp = props[2]
           elseif props[1]=="PosY" then
              yp = props[2]
           elseif props[1]=="PosZ" then
              zp = props[2]
           end
      end

            if IsJoint(tag)  then

            local outsidediam= GetProperty(tag,"OUTSIDE_DIAMETER") 
               DrawingAddCircle(xp,yp,outsidediam)

           elseif IsAppliance(tag) then
                 local shape= GetProperty(tag,'SHAPE')  
              if shape=="0" then
                 print("Adding rec appliance:".. tag)
                 local length = GetProperty(tag,"LENGTH")
                 local width = GetProperty(tag,"WIDTH")
                 local angle = GetProperty(tag,"ANGLE") 
                 print("length: "..length..", width: "..width..", anlgle: "..angle)
                 DrawingAddRectangle(xp,yp,length,width,angle) 

              elseif shape=="1" then
                 print("Adding vc appliance:".. tag)
                 local outsidediam= GetProperty(tag,"DIAMETER")
                 print("outsidediam: "..outsidediam)
                 DrawingAddCircle(xp,yp,outsidediam)

              elseif  shape=="2" then
                 local outsidediam= GetProperty(tag,"DIAMETER")
                 local  length = GetProperty(tag,"LENGTH")
                 local angle = GetProperty(tag,"ANGLE")
                 print("Adding vc appliance:".. tag)
                 print("length: "..length..", outsidediam: "..outsidediam..", anlgle: "..angle)

                 DrawingAddRectangle(xp,yp,length, outsidediam,angle)
              end
            elseif IsLinearLink(tag)  then

              local nodes = GetLinkNodes(tag);
              local node1tag = nodes[1]
              local node2tag = nodes[2]

              local p1x =  GetProperty(node1tag,"X") 
              local p1y =  GetProperty(node1tag,"Y") 
              local p2x =  GetProperty(node2tag,"X")
              local p2y =  GetProperty(node2tag,"Y")

              DrawingAddLine(p1x,p1y,p2x,p2y )

           elseif type=="WALL" then

            local node1tag =""
            local node2tag = ""

            local nodes = GetLinkNodes(tag);
            for i,ele in ipairs(nodes) do
           
                if IsBuildingCulomn(ele) then
                    if node1tag =="" then
                        node1tag =ele
                    elseif  node2tag =="" then
                        node2tag =ele
                    end
                end
            end 
            
            if node1tag ~="" and node2tag ~= "" then

            local p1x =  GetProperty(node1tag,"X") 
            local p1y =  GetProperty(node1tag,"Y") 
            local p2x =  GetProperty(node2tag,"X")
            local p2y =  GetProperty(node2tag,"Y")

            DrawingAddLine(p1x,p1y,p2x,p2y )
           end 
       end
end

PrintCanvas(100) 
local filename = "Drawing "..now..".dxf"
CanvasSaveAsDXF(filename);
print(filename.." ".."saved.")
