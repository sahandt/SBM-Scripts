--[[ To run this script , you should add "Generic Pipe Section Beams, mm" catalog to the user script.]]

CreateNewImperialProject();

local kip2N ;
kip2N= 4448.222

local kpin_to_Npm ;
kpin_to_Npm= 17543863.64

local inch2m;
inch2m = 0.0254;

function F2C(f)
    return (f - 32) * 5 / 9
end

function inverseFahrenheitToInverseCelsius(invF)
    return invF * (5 / 9)
end

--[[ Node data]]
local nodes = {}

local node_data = {
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 100.0, 0.0, 0.0},
    {0.0, 50.0, 100.0, 0.0},
    {100.0, 0.0, 0.0, 0.0},
    {100.0, 100.0, 0.0, 0.0},
    {100.0, 50.0, 100.0, 0.0},
    {200.0, 0.0, 0.0, 0.0},
    {200.0, 100.0, 0.0, 0.0},
    {200.0, 50.0, 100.0, 0.0},
    {300.0, 0.0, 0.0, 0.0},
    {300.0, 100.0, 0.0, 0.0},
    {300.0, 50.0, 100.0, 0.0},
    {400.0, 0.0, 0.0, 0.0},
    {400.0, 100.0, 0.0, 0.0},
    {400.0, 50.0, 100.0, 0.0},
    {500.0, 0.0, 0.0, 0.0},
    {500.0, 100.0, 0.0, 0.0},
    {500.0, 50.0, 100.0, 0.0}
}

for i, data in ipairs(node_data) do
    InputClear();
    InputAddPoint(data[1]*inch2m, data[2]*inch2m, data[3]*inch2m);
    for tag in CreateElement('STRUCT_NODE') do
        nodes[i] = tag;
    end
end

--[[ Reaction data]]
local restrained_nodes = {nodes[1], nodes[3], nodes[16], nodes[18]}
for _, node in ipairs(restrained_nodes) do
    SetStrucNodeRestraint(node, true, true, true, false, false, false)
end


--[[ Frame element data]]
local links = {}
local link_data = {
    {nodes[1], nodes[2]},
    {nodes[2], nodes[3]},
    {nodes[1], nodes[3]},
    {nodes[1], nodes[4]},
    {nodes[2], nodes[5]},
    {nodes[3], nodes[6]},
    {nodes[3], nodes[4]},
    {nodes[2], nodes[4]},
    {nodes[2], nodes[6]},
    {nodes[4], nodes[5]},
    {nodes[5], nodes[6]},
    {nodes[4], nodes[6]},
    {nodes[4], nodes[7]},
    {nodes[5], nodes[8]},
    {nodes[6], nodes[9]},
    {nodes[4], nodes[9]},
    {nodes[5], nodes[9]},
    {nodes[4], nodes[8]},
    {nodes[7], nodes[8]},
    {nodes[8], nodes[9]},
    {nodes[7], nodes[9]},
    {nodes[7], nodes[10]},
    {nodes[8], nodes[11]},
    {nodes[9], nodes[12]},
    {nodes[9], nodes[10]},
    {nodes[8], nodes[10]},
    {nodes[8], nodes[12]},
    {nodes[10], nodes[11]},
    {nodes[11], nodes[12]},
    {nodes[10], nodes[12]},
    {nodes[10], nodes[13]},
    {nodes[11], nodes[14]},
    {nodes[12], nodes[15]},
    {nodes[10], nodes[15]},
    {nodes[11], nodes[15]},
    {nodes[10], nodes[14]},
    {nodes[13], nodes[14]},
    {nodes[14], nodes[15]},
    {nodes[13], nodes[15]},
    {nodes[13], nodes[16]},
    {nodes[14], nodes[17]},
    {nodes[15], nodes[18]},
    {nodes[15], nodes[16]},
    {nodes[14], nodes[16]},
    {nodes[14], nodes[18]},
    {nodes[16], nodes[17]},
    {nodes[17], nodes[18]},
    {nodes[16], nodes[18]}
}
for i, data in ipairs(link_data) do
    InputClear();
    InputAddElement(data[1]);
    InputAddElement(data[2]);
    for tag in CreateElementFromCatalog('Generic Pipe Section Beams, mm','STRUCT_LINK',4) do
        links[i] = tag;
    end
end


SetProperty("Structural System", "SHEAR_DEFORMATION_EFFECTS", true);
SetProperty("Structural System", "GEOMETRIC_STIFFNESS_EFFECTS", true);
SetProperty("Structural System", "EXAGGERATION_FACTOR", 10.0);
SetProperty("Structural System", "ZOOM_SCALE", 2.5);
SetProperty("Structural System", "X_AXIS_INCREMENT", 12.0*inch2m);

SetProperty("Structural System", "NUMBER_OF_STATIC_LOAD_CASES", 1);

SetProperty("Structural System", "GX", 0.0);
SetProperty("Structural System", "GY", 0.0);
SetProperty("Structural System", "GZ", -9.806);

local links_to_load = {5, 14, 23, 32, 41}

for _, i in ipairs(links_to_load) do
  AddStrucLinkUniformLoad(links[i], 1, 0.0, -1.1*kpin_to_Npm, 0.0, 'Uniform Load ' .. i)
end

SetProperty("Structural System", "NUMBER_OF_MODES", 10);
SetProperty("Structural System", "MMETHOD", 0); --[[ Subspace Jacobi]]
SetProperty("Structural System", "MASS_MATRIX", 0); --[[ Consistent mass]]
SetProperty("Structural System", "FREQUENCY_CONVERGENCE_TOLERANCE", 1e-9);
SetProperty("Structural System", "SHIFT_FACTOR", 0.0);
SetProperty("Structural System", "EXAGG_MODAL", 2.0);
SetProperty("Structural System", "NUMBER_OF_MODES_TO_ANIMATE", 5);
SetProperty("Structural System", "PAN_RATE", 2.0);


print("Model creation complete.");
