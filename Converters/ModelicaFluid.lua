--[[This script converts current project model to a Modelica model, using Modelica.Fluid components, and saves the file in MOD directory inside working folder]]
local diagramScale =10
local diagramIconSize  =0.5

local tag = ""
local type= ""
local xp = 0
local yp = 0
local zp =0

local airtag="PROJECT_AIR"
if not CheckMaterialTagExists(airtag) then
  MaterialAddtoCollection(airtag,"G20")
end
local airtemp = MaterialGetProperty(airtag, 'TEMPERATURE')
local airpress = MaterialGetProperty(airtag, 'ABS_PRESSURE') 

ModelicaClearAll()
local now = GetDateTimeNow("yy MM dd hh mm")
CheckDuplicate(true)

function Tag2ModelicaTypeName( Tag)
    return  string.lower( string.gsub(Tag, " ", "_"))
end

function GetPumpflowCharacteristic(CurveFormula,maxFlow,N)
    local res = "redeclare function flowCharacteristic =  Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow (  V_flow_nominal={"
    local V_flow_nominal=""
    local head_nominal = ""
   local i = 1
   local f=0
     while i<=N do
          f =   maxFlow*i/N
          V_flow_nominal = V_flow_nominal..f
          head_nominal =  head_nominal ..ParseMathExpression(CurveFormula,"x",f)
          if i<N then 
                 V_flow_nominal= V_flow_nominal..","
                 head_nominal = head_nominal..","
          end
          i = i + 1
     end

    res= res..V_flow_nominal
    res = res.."}, head_nominal={"
    res= res..head_nominal
    res=res.."})"
    return res
end

function GetPortNumber(VesselTag, NozzleTag)
 local nozzles =GetLinkNodes(VesselTag)
     local noznum =0;

     for i,ele in ipairs(nozzles) do
             type = GetElementType(ele)
             tag = GetProperty(ele,"TAG")
           if type =="PIPE_FITTING" then 
             noznum =noznum +1
             if  tag == NozzleTag then 
                return noznum
             end
           end
     end
    return 0
end

function SetPortData(elementTag, compAddress, setPortData )

     local nozzles =GetLinkNodes(elementTag)
     local nozc = #nozzles
     local noznum =0;
     local portdata = ""
     for i,ele in ipairs(nozzles) do
             type = GetElementType(ele)
             tag = GetProperty(ele,"TAG")
           if type =="PIPE_FITTING" then 
             local fitdiam = GetProperty( tag,"OUTSIDE_DIAMETER")
             noznum =noznum +1
             if portdata~="" then portdata = portdata.."," end
             portdata =portdata.." Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter="..fitdiam..")"
         end
     end
     local var6=ModelicaAddIntegerVariable(compAddress,"nPorts")
     ModelicaSetStart(var6,noznum)
     if setPortData then
        local var5=ModelicaAddBooleanVariable(compAddress,"use_portsData")
        ModelicaSetStart(var5,"true")
        ModelicaComponentAddStartAttribute(compAddress,"portsData={"..portdata.."}")
     end
end

function GetLinkTag( linkstable, linknumber)
      local ltag = ""
      ele = linkstable[linknumber]
      for j,props in ipairs(ele) do
           if props[1]=="Tag" then
             ltag = props[2]
           end
     end
     if ltag ~="" then
        return ltag
     end 
    return ""
end

function GetConnectionAnnotation(element1Tag, element2Tag)
   return "Line(points = {{"..GetProperty(element1Tag,"X")*diagramScale..", "..GetProperty(element1Tag,"Y")*diagramScale.."}, {"..GetProperty(element2Tag,"X")*diagramScale..", "..GetProperty(element2Tag,"Y")*diagramScale.."}}, color = {0, 127, 255})"
end

function MainModelAddElement(nmodel, elementTag, elementType, xp,yp,zp)
      local compAddress ="";
     if  elementType=="RECT_AS_TANK" or elementType=="VCYL_AS_TANK" or elementType=="HCYL_AS_TANK" then 
      compAddress =ModelicaAddComponent(nmodel,"Modelica.Fluid.Vessels.OpenTank", Tag2ModelicaTypeName( elementTag))
     local var1=  ModelicaAddRealVariable(compAddress,"T_start")
     ModelicaSetStart(var1,airtemp+273.15)
     local rectw = GetProperty(elementTag, "WIDTH")
     local rectl = GetProperty(elementTag, "LENGTH")
     local recth = GetProperty(elementTag, "HEIGHT")
     local cyldiam = GetProperty(elementTag, "DIAMETER")
     local rectinitl = GetProperty(elementTag, "INIT_LIQ_ELEV")
     local var2=  ModelicaAddRealVariable(compAddress,"crossArea")
     if  elementType=="RECT_AS_TANK" then
        ModelicaSetStart(var2,rectw *rectl)
     elseif  elementType=="VCYL_AS_TANK" then
        ModelicaSetStart(var2,math.pi *cyldiam*cyldiam/4)
     end
     local var3=  ModelicaAddRealVariable(compAddress,"height")
     ModelicaSetStart(var3,recth)
     local var4=  ModelicaAddRealVariable(compAddress,"level_start")
     ModelicaSetStart(var4,rectinitl)
     SetPortData(elementTag, compAddress,true )

    elseif   elementType=="PIPE" then
      compAddress =ModelicaAddComponent(nmodel,"Modelica.Fluid.Pipes.DynamicPipe", Tag2ModelicaTypeName( elementTag))
     local pipdiam = GetProperty(elementTag, "OUTSIDE_DIAMETER")
     local piplen = GetProperty(elementTag, "PIPE_LENGTH")
     local pipthk = GetProperty(elementTag, "WALL_THICKNESS")
     local pipk = GetProperty(elementTag, "ABSOLUTE_ROUGHNESS") 
     local fitting1h = GetProperty( Get1stNode( elementTag), "Z")
     local fitting2h = GetProperty( Get2ndNode( elementTag), "Z")
     local var0=ModelicaAddBooleanVariable(compAddress,"allowFlowReversal")
     ModelicaSetStart(var0,"true")

     local var1=  ModelicaAddRealVariable(compAddress,"diameter")
     ModelicaSetStart(var1,pipdiam-2*pipthk )
     
     local var2=  ModelicaAddRealVariable(compAddress,"length")
     ModelicaSetStart(var2,piplen)

     local var3=  ModelicaAddRealVariable(compAddress,"height_ab")
     ModelicaSetStart(var3,fitting2h-fitting1h )

     local var4=  ModelicaAddRealVariable(compAddress,"roughness")
     ModelicaSetStart(var4, pipk )

    elseif   elementType=="CHVALVE" then 
      compAddress =ModelicaAddComponent(nmodel,"Modelica.Thermal.FluidHeatFlow.Components.OneWayValve", Tag2ModelicaTypeName( elementTag))
    elseif   IsValve(elementTag) then 
      compAddress =ModelicaAddComponent(nmodel,"Modelica.Thermal.FluidHeatFlow.Components.Valve", Tag2ModelicaTypeName( elementTag))
    elseif   elementType=="PUMP" then 

     local pumpl = GetProperty(elementTag, "LENGTH")
     local pumpdiam = GetProperty(elementTag, "DIAMETER")
     local maxFlow = GetProperty(elementTag,"MAX_FLOW" )
     local CurveFormula = GetProperty(elementTag,"HEAD_FLOW_CURVE_FORMULA"  )

      compAddress =ModelicaAddComponent(nmodel,"Modelica.Fluid.Machines.PrescribedPump", Tag2ModelicaTypeName( elementTag))
     local varp1=ModelicaAddBooleanVariable(compAddress,"use_N_in")
     ModelicaSetStart(varp1,"false")
     local varp2=  ModelicaAddRealVariable(compAddress,"V")
     ModelicaSetStart(varp2,pumpl*pumpdiam*pumpdiam *math.pi/4)

     local varp3=  ModelicaAddRealVariable(compAddress,"nParallel")
     ModelicaSetStart(varp3,1)
     local varp4=  ModelicaAddRealVariable(compAddress,"p_b_start")
     ModelicaSetStart(varp4,600000)
     local varp5=  ModelicaAddRealVariable(compAddress,"T_start")
     ModelicaSetStart(varp5,airtemp+273.15)
     ModelicaComponentAddStartAttribute(compAddress , "energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial")
     ModelicaComponentAddStartAttribute(compAddress , "massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial")
     ModelicaComponentAddStartAttribute(compAddress ,  GetPumpflowCharacteristic(CurveFormula,maxFlow,3))

    elseif   elementType=="HYDRAULIC_APPLIANCE" then 
      compAddress =ModelicaAddComponent(nmodel,"Modelica.Fluid.Sources.FixedBoundary", Tag2ModelicaTypeName( elementTag))
     local var1=ModelicaAddBooleanVariable(compAddress,"use_T")
     ModelicaSetStart(var1,"true")
     local var2=  ModelicaAddRealVariable(compAddress,"T")
     ModelicaSetStart(var2,airtemp+273.15)
     local var3=  ModelicaAddRealVariable(compAddress,"p")
     ModelicaSetStart(var3,airpress)
     SetPortData(elementTag, compAddress,false )

    end
    ModelicaComponentAddStartAttribute(compAddress , "redeclare package Medium = Medium")
    ModelicaSetAnnotation(compAddress, "Placement(visible = true, transformation(origin = {"..xp..","..yp.."}, extent = {{-"..diagramIconSize..", -"..diagramIconSize.."}, {"..diagramIconSize..", "..diagramIconSize.."}}, rotation = 0))")
end



function MainModelAddConnection(nmodel, elementTag, elementType)
    local conadr = ""
    if   elementType=="PIPE_FITTING" then 
        local links = GetConnectedLinks(elementTag)
        local linkNumber= #links;
        if IsAttached(elementTag)  then
            linkNumber =linkNumber +1
        end
        local bendName= Tag2ModelicaTypeName( elementTag)
        if linkNumber==2 then
           local ltag = GetLinkTag( links, 1)
           local linkname= Tag2ModelicaTypeName( ltag) 
           local linkAddress = ModelicaGetAddressFromName(linkname)
           local link1port=""
           if GetNodeSide(ltag,elementTag) then
                  link1port="port_b"
           else
                 link1port="port_a"
           end
           if IsAttached(elementTag)  then

               local holderTag= GetHolderTag(elementTag);
               local holderType = GetElementType(holderTag)
               local holdername= Tag2ModelicaTypeName(holderTag )
               local holderAddress = ModelicaGetAddressFromName(holdername)

               if holderType == "PUMP" then
                     local holderSide= GetProperty(elementTag, "SIDE")

                     if holderSide== "1" then
                       conadr = ModelicaAddConnection(nmodel, linkAddress, link1port,holderAddress,"port_a")
                       ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag, holderTag))
                     else
                      conadr =ModelicaAddConnection(nmodel, linkAddress, link1port , holderAddress,"port_b")
                       ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag, holderTag))
                     end
              else
                 conadr = ModelicaAddConnection(nmodel, linkAddress, link1port,holderAddress,"ports["..GetPortNumber(holderTag,elementTag).."]")
                       ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag, holderTag))
              end
            else
               local ltag2 = GetLinkTag( links, 2)
               linkname2= Tag2ModelicaTypeName( ltag2) 
               linkAddress2 = ModelicaGetAddressFromName(linkname2)

               if GetNodeSide(ltag2,elementTag) then
                  conadr = ModelicaAddConnection(nmodel, linkAddress, link1port, linkAddress2,"port_b")
               else
                  conadr = ModelicaAddConnection(nmodel, linkAddress, link1port, linkAddress2,"port_a")
               end
               ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag2, ltag))
          end
               
        elseif  linkNumber==3 then
          local ltag = GetLinkTag( links, 1)
           local linkname= Tag2ModelicaTypeName( ltag) 
           local linkAddress = ModelicaGetAddressFromName(linkname)
           local link1port=""
           if GetNodeSide(ltag,elementTag) then
                  link1port="port_b"
           else
                 link1port="port_a"
           end
           local ltag2 = GetLinkTag( links, 2)
               linkname2= Tag2ModelicaTypeName( ltag2) 
               linkAddress2 = ModelicaGetAddressFromName(linkname2)
               local link2port = ""
               if GetNodeSide(ltag2,elementTag) then
                  link2port ="port_b"
               else
                  link2port ="port_a"
               end
               conadr = ModelicaAddConnection(nmodel, linkAddress, link1port, linkAddress2, link2port)
               ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag2, ltag))
               if IsAttached(elementTag)  then

                  local holderTag= GetHolderTag(elementTag);
                  local holderType = GetElementType(holderTag)
                  local holdername= Tag2ModelicaTypeName(holderTag )
                  local holderAddress = ModelicaGetAddressFromName(holdername)

                 if holderType == "PUMP" then
                     local holderSide= GetProperty(elementTag, "SIDE")

                     if holderSide== "1" then
                       conadr = ModelicaAddConnection(nmodel, linkAddress, link1port,holderAddress,"port_a")
                       ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag, holderTag))
                     else
                      conadr =ModelicaAddConnection(nmodel, linkAddress, link1port , holderAddress,"port_b")
                       ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag, holderTag))
                     end
                 else
                 conadr = ModelicaAddConnection(nmodel, linkAddress, link1port,holderAddress,"ports["..GetPortNumber(holderTag,elementTag).."]")
                       ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag, holderTag))
                 end
            else
               local ltag3 = GetLinkTag( links, 3)
               linkname3= Tag2ModelicaTypeName( ltag3) 
               linkAddress3 = ModelicaGetAddressFromName(linkname3)

               if GetNodeSide(ltag3,elementTag) then
                  conadr = ModelicaAddConnection(nmodel, linkAddress, link1port, linkAddress3,"port_b")
               else
                  conadr = ModelicaAddConnection(nmodel, linkAddress, link1port, linkAddress3,"port_a")
               end
               ModelicaSetAnnotation( conadr, GetConnectionAnnotation(ltag3, ltag))
          end

        end
      end
end

local ele_tbl= GetAllElements()

local gmodel = ModelicaAddModel("","MainModel","Main model containing elements and connections")
ModelicaModifyModel(gmodel,"replaceable package Medium = Modelica.Media.Water.StandardWaterOnePhase  constrainedby Modelica.Media.Interfaces.PartialMedium")
 ModelicaSetAnnotation(gmodel, "uses(Modelica(version = \"4.0.0\"))")

for i,ele in ipairs(ele_tbl) do
      for j,props in ipairs(ele) do
           if props[1]=="Type" then
             type = props[2]
           end
           if props[1]=="Tag" then
             tag = props[2]
           end
          if props[1]=="PosX" then
              xp = props[2]* diagramScale
           end
           if props[1]=="PosY" then
              yp = props[2]* diagramScale
           end
           if props[1]=="PosZ" then
              zp = props[2]* diagramScale
           end
     end

     if type ~="" then
             MainModelAddElement(gmodel , tag , type, xp,yp,zp)
     end 
end

for i,ele in ipairs(ele_tbl) do
      for j,props in ipairs(ele) do
           if props[1]=="Type" then
             type = props[2]
           end
           if props[1]=="Tag" then
             tag = props[2]
           end
     end
     if type ~="" then
             MainModelAddConnection(gmodel , tag , type)
     end 
end
local syscom =ModelicaAddComponent(gmodel ,"Modelica.Fluid.System","system")
ModelicaSetInner(syscom)
ModelicaComponentAddStartAttribute(syscom,"energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial")

local filename ="Model "..now..".mo"
ModelicaSavePackage(filename)
print("File: "..filename.." is saved in application work folder!")
OpenAppWorkingFolder('MOD');
