--[[ This script creates a 2D truss model based on exA.3dd example. ]]
--[[ To run this script , you should add "Generic Hollow Round Section Beams, inches" catalog to the user script.]]

CreateNewImperialProject(); 

local kip2N ;
kip2N= 4448.222

local inch2m;
inch2m = 0.0254;

function F2C(f)
    return (f - 32) * 5 / 9
end

function inverseFahrenheitToInverseCelsius(invF)
    return invF * (5 / 9)
end



--[[ Define Nodes ]]
local nodes = {}
local node_data = {
 {0.0, 0.0, 0.0}, 
 {120.0* inch2m, 0.0, 0.0}, 
 {240.0* inch2m, 0.0, 0.0},
 {360.0* inch2m, 0.0, 0.0},
 {480.0* inch2m, 0.0, 0.0},
 {600.0* inch2m, 0.0, 0.0},
 {720.0* inch2m, 0.0, 0.0},
 {120.0* inch2m, 120.0* inch2m, 0.0},
 {240.0* inch2m, 120.0* inch2m, 0.0},
 {360.0* inch2m, 120.0* inch2m, 0.0},
 {480.0* inch2m, 120.0* inch2m, 0.0},
 {600.0* inch2m, 120.0* inch2m, 0.0}
}

for i, data in ipairs(node_data) do
    InputClear();
    InputAddPoint(data[1], data[2], data[3]);
    for tag in CreateElement('STRUCT_NODE') do
        nodes[i] = tag;
    end
end

--[[ Define Links ]]
local links = {}
local link_data = {
  {nodes[1], nodes[2]},
  {nodes[2], nodes[3]},
 {nodes[3], nodes[4]},
 {nodes[4], nodes[5]},
  {nodes[5], nodes[6]},
 {nodes[6], nodes[7]},
 {nodes[1], nodes[8]},
 {nodes[2], nodes[8]},
 {nodes[2], nodes[9]},
 {nodes[3], nodes[9]},
 {nodes[4], nodes[9]},
 {nodes[4], nodes[10]},
 {nodes[4], nodes[11]},
 {nodes[5], nodes[11]},
 {nodes[6], nodes[11]},
 {nodes[6], nodes[12]},
 {nodes[7], nodes[12]},
 {nodes[8], nodes[9]},
 {nodes[9], nodes[10]},
 {nodes[10], nodes[11]},
 {nodes[11], nodes[12]}
}

for i, data in ipairs(link_data) do
    InputClear();
    InputAddElement(data[1]);
    InputAddElement(data[2]);
    for tag in CreateElementFromCatalog('Generic Hollow Round Section Beams, inches','STRUCT_LINK',1) do
        links[i] = tag;
    end
end

--[[ Set Node Restraints ]]

SetStrucNodeRestraint(nodes[1], true, true, true, true, true, false);
SetStrucNodeRestraint(nodes[2], false, false, true, true, true, false);
SetStrucNodeRestraint(nodes[3], false, false, true, true, true, false);
SetStrucNodeRestraint(nodes[4], false, false, true, true, true, false);
SetStrucNodeRestraint(nodes[5], false, false, true, true, true, false);
SetStrucNodeRestraint(nodes[6], false, false, true, true, true, false);
SetStrucNodeRestraint(nodes[7], false, true, true, true, true, false);
SetStrucNodeRestraint(nodes[8], true, false, true, true, true, false);
SetStrucNodeRestraint(nodes[9], false, false, true, true, true, false);
SetStrucNodeRestraint(nodes[10], false, false, true, true, true, false);
SetStrucNodeRestraint(nodes[11], false, false, true, true, true, false);
SetStrucNodeRestraint(nodes[12], false, false, true, true, true, false);


--[[ Set Node Loads ]]
--[[Case 1]]
AddStrucNodeLoad(nodes[2], 1, 0.0, -10.0*kip2N, 0.0, 0.0, 0.0, 0.0, 'Node Load 1');
AddStrucNodeLoad(nodes[3], 1, 0.0, -20.0*kip2N, 0.0, 0.0, 0.0, 0.0, 'Node Load 2');
AddStrucNodeLoad(nodes[4], 1, 0.0, -20.0*kip2N, 0.0, 0.0, 0.0, 0.0, 'Node Load 3');
AddStrucNodeLoad(nodes[5], 1, 0.0, -10.0*kip2N, 0.0, 0.0, 0.0, 0.0, 'Node Load 4');
AddStrucNodeLoad(nodes[6], 1, 0.0, -20.0*kip2N, 0.0, 0.0, 0.0, 0.0, 'Node Load 5');

AddStrucNodeDisplacement(nodes[8], 1, 0.1* inch2m , 0.0 , 0.0 , 0.0 , 0.0 , 0.0, 'Node prescribed displacements 1');


--[[ Case 2]]
--[[ Case 2]]
AddStrucNodeLoad(nodes[3], 2, 20.0*kip2N, 0.0, 0.0, 0.0, 0.0, 0.0, 'Node Load 6');
AddStrucNodeLoad(nodes[4], 2, 10.0*kip2N, 0.0, 0.0, 0.0, 0.0, 0.0, 'Node Load 7');
AddStrucNodeLoad(nodes[5], 2, 20.0*kip2N, 0.0, 0.0, 0.0, 0.0, 0.0, 'Node Load 8');

AddStrucNodeDisplacement(nodes[1], 2, 0.0 , -0.1* inch2m , 0.0 , 0.0 , 0.0 , 0.0, 'Node prescribed displacements 2');
AddStrucNodeDisplacement(nodes[8], 2, 0.1* inch2m , 0.0 , 0.0 , 0.0 , 0.0 , 0.0, 'Node prescribed displacements 3');

--[[ Set Temperature Loads ]]

AddStrucLinkTemperatureLoad(links[10],2,  inverseFahrenheitToInverseCelsius( 6e-12), 5.0* inch2m, 5.0* inch2m, F2C(10), F2C(10), F2C(10), F2C(10), 'Temp Load 1');
AddStrucLinkTemperatureLoad(links[13],2,  inverseFahrenheitToInverseCelsius( 6e-12), 5.0* inch2m, 5.0* inch2m, F2C(15), F2C(15), F2C(15), F2C(15), 'Temp Load 2');
AddStrucLinkTemperatureLoad(links[15],2,  inverseFahrenheitToInverseCelsius( 6e-12), 5.0* inch2m, 5.0* inch2m, F2C(17), F2C(17), F2C(17), F2C(17), 'Temp Load 3');

SetProperty("Structural System", "GX", 0.0);
SetProperty("Structural System", "GY", 0.0);
SetProperty("Structural System", "GZ", 0.0);


SetProperty("Structural System", "SHEAR_DEFORMATION_EFFECTS", false);
SetProperty("Structural System", "GEOMETRIC_STIFFNESS_EFFECTS", false);
SetProperty("Structural System", "EXAGGERATION_FACTOR", 50.0);
SetProperty("Structural System", "ZOOM_SCALE", 1);
SetProperty("Structural System", "X_AXIS_INCREMENT", -1);
SetProperty("Structural System", "NUMBER_OF_MODES", 0);


print("Model exA creation complete.");
