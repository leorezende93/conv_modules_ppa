import math
import copy 
import time

def get_input_size(input_h, input_w, input_c):
   input_size = input_w*input_h*input_c
   return input_size

def get_output_layer_dimension(input_h, n_conv_layers, filter_dimension, stride_h):
   layer_dimension = [0] * (n_conv_layers + 2)

   if ((input_h-filter_dimension[0])%2 != 0):
      layer_dimension[0] = math.ceil(((input_h-filter_dimension[0]+1)/stride_h[0]))
   else:
      layer_dimension[0] = math.ceil(((input_h-filter_dimension[0])/stride_h[0])+1)

   for i in range(1,n_conv_layers):
      if ((input_h-filter_dimension[i])%2 != 0):
         layer_dimension[i] = math.ceil(((layer_dimension[i-1]-filter_dimension[i]+1)/stride_h[i]))
      else:
         layer_dimension[i] = math.ceil(((layer_dimension[i-1]-filter_dimension[i])/stride_h[i])+1)

   layer_dimension[n_conv_layers] = math.ceil(layer_dimension[n_conv_layers-1])*math.ceil(layer_dimension[n_conv_layers-1])
   layer_dimension[n_conv_layers+1] = 10
   return layer_dimension

def get_input_channel(input_c, n_conv_layers, filter_channel):
   input_channel = [0] * (n_conv_layers + 1)
   input_channel[0] = input_c
   for i in range (1,n_conv_layers):
      input_channel[i] = filter_channel[i-1]
   input_channel[n_conv_layers] = 1
   return input_channel
   
def create_dictionary(model):
   # Create dictionary
   modelDict = {}

   # Initialize layer id to insert layers to dictionary
   layerId = 0

   # Iterate through model layers to populate dictionary
   for layer in list(model.layers):
     # Initialize layer in dictionary
     modelDict[layerId] = {}
     layerName = layer.name
     modelDict[layerId]["name"] = layerName
     # Get type of layer
     layerType = type(layer).__name__
     modelDict[layerId]["type"] = layerType
     # If layer is dense
     if layerType == "Dense":
       # Collect activation function
       layerActivation = str(layer.activation).split(" ")[1]
       modelDict[layerId]["activation"] = layerActivation
       # Initialize neuron dict
       modelDict[layerId]["neuron"] = {}
       # Iterate through variables of this layer
       for layerVar in layer.trainable_variables:
         # Check if weights
         if layerVar.name.split("/")[1] == "kernel:0":
           numNeurons = layerVar.shape[1]
           for neuronId in range(numNeurons):
             # Add to dict
             if not neuronId in modelDict[layerId]["neuron"]:
               modelDict[layerId]["neuron"][neuronId] = {}
             # Change matrix to represent weights per neuron instead of weights per input feature
             modelDict[layerId]["neuron"][neuronId]["weights"] = layerVar[:,neuronId].numpy()
         # Check if bias
         elif layerVar.name.split("/")[1] == "bias:0":
           numNeurons = layerVar.shape[0]
           for neuronId in range(numNeurons):
             # Add to dict
             if not neuronId in modelDict[layerId]["neuron"]:
               modelDict[layerId]["neuron"][neuronId] = {}
             modelDict[layerId]["neuron"][neuronId]["bias"] = layerVar[neuronId].numpy()
     # If layer is conv
     elif layerType == "Conv2D":   
       layerActivation = str(layer.activation).split(" ")[1]
       modelDict[layerId]["activation"] = layerActivation
       # Initialize filter dict
       modelDict[layerId]["filter"] = {}
       # Iterate through variables of this layer
       for layerVar in layer.trainable_variables:
         # Check if weights
         if layerVar.name.split("/")[1] == "kernel:0":
           numFilters=layerVar.shape[3]
           for filterId in range(numFilters):
             # Add to dict
             if not filterId in modelDict[layerId]["filter"]:
               modelDict[layerId]["filter"][filterId] = {}
             modelDict[layerId]["filter"][filterId]["weights"] = layerVar[:,:,:,filterId].numpy()
         # Check if bias
         elif layerVar.name.split("/")[1] == "bias:0":
           numFilters = layerVar.shape[0]
           for filterId in range(numFilters):
             # Add to dict
             if not filterId in modelDict[layerId]["filter"]:
               modelDict[layerId]["filter"][filterId] = {}
             modelDict[layerId]["filter"][filterId]["bias"] = layerVar[filterId].numpy()
     layerId += 1
     
   return modelDict
   
def generate_orca_header(modelDict,shift,input_size,filter_dimension,filter_channel,layer_dimension,input_channel,testSet,testLabel,testSetSize):
   # Auxiliar variables
   cont = 0

   # Auxiliar strings
   string_weight = [" "] * max(filter_channel)
   string_weight[0] = "{"
   string_bias = "{"
   input_string = "int32_t Input[" + str(testSetSize) + "][" + str(input_size) + "] = {"
   label_string = "int16_t Label[" + str(testSetSize) + "] = {"
   string_shift = ""

   # Auxiliar strings for input
   pixel0 = []
   pixel1 = []
   pixel2 = []

   # Open file
   f = open("tensorflow.h", "w+")

   f.write("#include <stdint.h>")
   f.write("\n\n")

   string_shift = "#define SHIFT " + str(shift)
   f.write(string_shift)
   f.write("\n\n")

   for layerId in modelDict:
     if modelDict[layerId]["type"] == "Conv2D":
       string_weight[0] = "int16_t Layer" + str(layerId+1) + "_Weights[" + str(filter_channel[layerId]*input_channel[layerId]*(filter_dimension[layerId]**2)) + "] = " + "{"
       string_bias = "int16_t Layer" + str(layerId+1) + "_Bias[" + str(filter_channel[layerId]) + "] = " + "{"
       for filterId in modelDict[layerId]["filter"]:
         string_bias = string_bias + str(int(modelDict[layerId]["filter"][filterId]["bias"]*shift)) + ","
         for weightChannel in modelDict[layerId]["filter"][filterId]["weights"]:
           for weightsH in weightChannel:          
             if layerId == 0:
               aux_idx_range = input_channel[0]
             else:
               aux_idx_range = filter_channel[layerId-1]
             for weightValue,ofmapChannel,inputChannel in zip(weightsH,range(aux_idx_range),range(input_channel[layerId])):
               weight_input = int(float(weightValue)*shift)  
               if layerId == 0:
                 string_weight[ofmapChannel] = string_weight[ofmapChannel] + str(int(weight_input)) + ","
               else:
                 string_weight[ofmapChannel] = string_weight[ofmapChannel] + str(int(weight_input)) + ","
         if layerId == 0:
           aux_idx_range = input_channel[0]
         else:
           aux_idx_range = filter_channel[layerId-1]
         for i in range(aux_idx_range):
           cont = cont + 1 
           if cont == filter_channel[layerId]*aux_idx_range:
             cont = 0
             string_weight[i] = string_weight[i][:len(string_weight[i])-1] + "};"
             f.write(string_weight[i])
           else:
             f.write(string_weight[i]) 
           string_weight[i] = " "
           f.write("\n")
       
       string_bias = string_bias[:len(string_bias)-1] + "};"
       f.write("\n")
       f.write(string_bias)

       string_bias = "{"
       string_weight[0] = "{"
       f.write("\n\n")

     if modelDict[layerId]["type"] == "Dense":
       cont = 0
       string_weight[0] = "int16_t Dense_Weights[" + str(layer_dimension[layerId]*(layer_dimension[layerId-2]**2)) + "] = " + "{"
       string_bias = "int16_t Dense_Bias[" + str(layer_dimension[layerId]) + "] = " + "{"
       for neuronId in modelDict[layerId]["neuron"]:
         string_bias = string_bias + str(int(modelDict[layerId]["neuron"][neuronId]["bias"]*shift)) + ","
         for weightValue in modelDict[layerId]["neuron"][neuronId]["weights"]:
           weight_input  = int(float(weightValue)*shift)
           string_weight[0] = string_weight[0] + str(weight_input) + ","
         cont = cont + 1
         if cont == layer_dimension[layerId]:
           string_weight[0] = string_weight[0][:len(string_weight[0])-1] + "};"
           f.write(string_weight[0])
         else:
           f.write(string_weight[0])
         string_weight[0] = " "
       string_bias = string_bias[:len(string_bias)-1] + "};"
       f.write("\n\n")
       f.write(string_bias)
       string_bias = "{"
       string_weight[0] = "{"
       f.write("\n\n")

   cont = 0
   cont_size = 0
   f.write(input_string)
   for i in range(testSetSize):
     for image in testSet[i]:
       for feature in image:
         for pixel in feature:
           if cont % 3 == 0:
             pixel0.append(int(pixel*shift))
           if cont % 3 == 1:
             pixel1.append(int(pixel*shift))
           if cont % 3 == 2:
             pixel2.append(int(pixel*shift))
           cont = cont + 1

     cont_size = 0
     for pixel in pixel0:
       if cont_size == 0:
         f.write("{") 
       f.write(str(pixel))
       f.write(",")
       cont_size = cont_size + 1

     for pixel in pixel1:
       f.write(str(pixel))
       f.write(",")
       cont_size = cont_size + 1

     for pixel in pixel2:
       if cont_size == input_size - 1:
         if i < testSetSize - 1:
           f.write(str(pixel))
           f.write("},")
           f.write("\n")
         else:
           f.write(str(int(pixel*shift)))
           f.write("}};")
           f.write("\n")
       else:
         f.write(str(pixel))
         f.write(",")
       cont_size = cont_size + 1
     pixel0 = []
     pixel1 = []
     pixel2 = []

   f.write("\n")
   f.write(label_string)
   for i in range(testSetSize):
     label = int(testLabel[i])
     if i < testSetSize - 1:
       f.write(str(label))
       f.write(",")
     else:
       f.write(str(label))
       f.write("};")
   f.write("\n")

   f.close()

def get_input_size(input_h, input_w, input_c):
   input_size = input_w*input_h*input_c
   return input_size
   
def generate_generic_file(X_SIZE, FILTER_WIDTH, CONVS_PER_LINE, MEM_SIZE, INPUT_SIZE, CARRY_SIZE):
   # Open file
   f = open("generic_file.txt", "w+")
   f.write("-gX_SIZE=" + str(X_SIZE) + " -gFILTER_WIDTH=" + str(FILTER_WIDTH) + " -gCONVS_PER_LINE=" + str(CONVS_PER_LINE) + " -gMEM_SIZE=" + str(MEM_SIZE) + " -gINPUT_SIZE=" + str(INPUT_SIZE) + " -gCARRY_SIZE=" + str(CARRY_SIZE) + "\n")
   f.close()
   
def generate_tcl_generic(X_SIZE, FILTER_WIDTH, CONVS_PER_LINE, MEM_SIZE, INPUT_SIZE, CARRY_SIZE):
   # Open file
   f = open("generic.tcl", "w+")
   f.write("set parameters {{X_SIZE " + str(X_SIZE) + "}" + " {FILTER_WIDTH " + str(FILTER_WIDTH) + "}" + " {CONVS_PER_LINE " + str(CONVS_PER_LINE) + "}" + " {MEM_SIZE " + str(MEM_SIZE) + "}" + " {INPUT_SIZE " + str(INPUT_SIZE) + "}" + " {CARRY_SIZE " + str(CARRY_SIZE) + "}}" + "\n")
   f.close()

def generate_vhdl_package(modelDict,shift,input_size,filter_dimension,filter_channel,stride_h,stride_w,layer_dimension,input_channel,app_channel,testSet):   
   # Index control
   m = 0
   n = 0
   filter_i = 0
   filter_j = 0

   # feature maps
   ifmap = []
   ofmap = []
   output = [0.0] * 10

   # Auxiliar strings for input
   pixel0 = []
   string_bias  = "constant bias_mem : padroes := ( "
   string_input  = "constant feature_mem : padroes := ( "
   string_weight = "constant weight_mem : padroes := ( "
   string_gold = "constant gold : padroes := ( "

   ifmap.clear()
   ofmap.clear()

   # Convolution variables
   acc = 0.0

   # Output feature map for each filter channel
   ofmap.append(copy.deepcopy(testSet[0]))

   # Initializing input feature map
   ifmap.append(copy.deepcopy(ofmap))
  
   for layerId in modelDict:
    if layerId == 0:
      if modelDict[layerId]["type"] == "Conv2D":
        for filterId in modelDict[layerId]["filter"]:
          for m in range(layer_dimension):
            for n in range(layer_dimension):
              acc = int(modelDict[layerId]["filter"][filterId]["bias"]*shift)
              for weightChannel in modelDict[layerId]["filter"][filterId]["weights"]:
                for weightsH in weightChannel:
                  for weightValue,ofmapChannel in zip(weightsH,range(input_channel)):
                    ifmap_input = int(float(ifmap[layerId][ofmapChannel][filter_i + m*stride_h][filter_j + n*stride_w][0])*shift)
                    weight_input = int(float(weightValue)*shift)
                    acc = int(acc) + int(ifmap_input*weight_input)
                    
                    #if layerId == 0:
                    #  print(weight_input," * ",ifmap_input)
                    
                  filter_j = filter_j + 1
                  if filter_j == filter_dimension:
                    filter_j = 0
                    filter_i = filter_i + 1
                    if filter_i == filter_dimension:
                      filter_i = 0
              acc_input = int(acc/shift)
              string_gold = string_gold + str(max(0,int(acc_input))) + ', '
          break
        break
      break
    break

   for layerId in modelDict:
     if layerId == 0:
       if modelDict[layerId]["type"] == "Conv2D":
         for filterId in modelDict[layerId]["filter"]:
           string_bias = string_bias + str(int(modelDict[layerId]["filter"][filterId]["bias"]*shift)) + ","
           for weightChannel in modelDict[layerId]["filter"][filterId]["weights"]:
             for weightsH in weightChannel:
               for weightValue,ofmapChannel in zip(weightsH,range(input_channel)):
                 weight_input = int(float(weightValue)*shift)

                 string_weight = string_weight + str(int(weight_input)) + ", "
                      
           string_weight = string_weight[:len(string_weight)-1] + " others=>0 );"
           break
       
         string_bias = string_bias[:len(string_bias)-1] + ", others=>0 );"
         
   cont = 0
   for image in testSet[0]:
    for feature in image:
      for pixel in feature:
        if app_channel > 1:
            if cont % 3 == 0:
              pixel0.append(int(pixel*shift))
            cont = cont + 1
        else:
          pixel0.append(int(pixel*shift))

   for pixel in pixel0:
     string_input = string_input + str(pixel) + ', '

   string_input = string_input[:len(string_input)-1] + " others=>0 );"
   string_gold = string_gold[:len(string_gold)-1] + " others=>0 );"

   # Open file
   f = open("tensorflow.vhd", "w+")

   f.write("LIBRARY ieee;\n")
   f.write("USE ieee.std_logic_1164.all;\n")
   f.write("USE ieee.std_logic_signed.all;\n")
   f.write("\tPACKAGE tensorflow_package is\n")
   f.write("\t\ttype padroes is array(0 to 1024) of integer;\n")
   f.write("\t\t" + string_bias + "\n")
   f.write("\t\t" + string_input + "\n")
   f.write("\t\t" + string_weight + "\n")
   f.write("\t\t" + string_gold + "\n")
   f.write("END tensorflow_package;\n")

   f.close()

def generate_orca_gold(modelDict,shift,input_size,filter_dimension,filter_channel,layer_dimension,input_channel,testSet,testLabel,stride_h,stride_w,testSetSize):
   # Dataset test variables
   cont_match = 0
   aux_idx_range = 0

   # Index control
   m = 0
   n = 0
   idx = 0
   filter_i = 0
   filter_j = 0

   # feature maps
   ifmap = []
   ofmap = []
   output = [0.0] * 10

   # string for ORCA gold
   string_orca_gold = " "

   for testCase in range(testSetSize):
     ifmap.clear()
     ofmap.clear()

     # Convolution variables
     # accumulator for each filter channel 
     size = max(filter_channel)
     acc = [0] * size

     # output feature map for each filter channel
     for i in range(size):
       ofmap.append(copy.deepcopy(testSet[testCase]))

     # Initializing input feature map
     ifmap.append(copy.deepcopy(ofmap))

     #print(ifmap)
     #time.sleep(3)

     # Auxiliar matrix for dense layer calculation
     flatten_output = [0.0] * layer_dimension[len(layer_dimension)-2]
     
     for layerId in modelDict:
       if modelDict[layerId]["type"] == "Conv2D":
         for filterId in modelDict[layerId]["filter"]:
           #print(str(int(modelDict[layerId]["filter"][filterId]["bias"]*shift)))
           for m in range(layer_dimension[layerId]):
             for n in range(layer_dimension[layerId]):
               acc[filterId] = int(modelDict[layerId]["filter"][filterId]["bias"]*shift)
               #print("bias ",int(modelDict[layerId]["filter"][filterId]["bias"]*shift))
               #print("acc ",acc[filterId])
               #for ifmapValue in (ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]]):
               #ifmapValue = ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]];
               for weightChannel in modelDict[layerId]["filter"][filterId]["weights"]:
                 for weightsH in weightChannel:
                   if layerId == 0:
                     aux_idx_range = input_channel[0]
                   else:
                     aux_idx_range = filter_channel[layerId-1]
                   for weightValue,ofmapChannel,inputChannel in zip(weightsH,range(aux_idx_range),range(input_channel[layerId])):
                     #print(ofmapChannel)
                     #print(inputChannel)
                     #print(ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]][filter_j + n*stride_w[layerId]][inputChannel])
                     #print(weightValue)
                     #time.sleep(3)
                     
                     #if layerId == 0:
                     #  acc[filterId] = int(acc[filterId]) + (float(ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]][filter_j + n*stride_w[layerId]][inputChannel])*float(weightValue))
                     #else:
                     #  acc[filterId] = int(acc[filterId]) + (float(ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]][filter_j + n*stride_w[layerId]][0])*float(weightValue))
                     
                     #print(inputChannel)
                     #print(ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]][filter_j + n*stride_w[layerId]]*shift)
                     
                     if layerId == 0:
                       ifmap_input = int(float(ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]][filter_j + n*stride_w[layerId]][inputChannel])*shift)
                       #print("0 -> ",int(float(ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]][filter_j + n*stride_w[layerId]][inputChannel])*shift))
                       #print("1 -> ",int(float(ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]][filter_j + n*stride_w[layerId]])*shift))
                     else:
                       ifmap_input = int(float(ifmap[layerId][ofmapChannel][filter_i + m*stride_h[layerId]][filter_j + n*stride_w[layerId]][0]))
                     weight_input = int(float(weightValue)*shift)
                     
                     #if layerId == 0:
                     #  print(weight_input," * ",ifmap_input)
                     
                     acc[filterId] = int(acc[filterId]) + int(ifmap_input*weight_input)
                                          
                   filter_j = filter_j + 1
                   if filter_j == filter_dimension[layerId]:
                     filter_j = 0
                     filter_i = filter_i + 1
                     if filter_i == filter_dimension[layerId]:
                       filter_i = 0
                         
                 #print(acc[filterId])  
               
               #acc_input = int((acc[filterId] >> 4))
               acc_input = int((acc[filterId]/shift))
               ofmap[filterId][m][n] = max(0,int(acc_input))
               #print(max(0.0,float(acc[filterId])))
               #time.sleep(3)
           
	   # Open file
           with open("orca_gold.txt", "a") as f:
             if layerId == 0:
               for m in range(layer_dimension[layerId]):
                 for n in range(layer_dimension[layerId]):
                   string_orca_gold = str(int(ofmap[filterId][m][n][0]))
                   f.write(string_orca_gold)
                   f.write(" ")
                 f.write("\n")
               f.write("\n")
             f.close()
	   
         ifmap.append(copy.deepcopy(ofmap))

       if modelDict[layerId]["type"] == "Flatten":   
         idx = 0
         for i in range(layer_dimension[layerId-1]):
           for j in range(layer_dimension[layerId-1]):    
             for k in range(filter_channel[layerId-1]):
               flatten_output[idx] = float(ifmap[layerId][k][i][j][0])
               idx = idx + 1

       if modelDict[layerId]["type"] == "Dense":
         idx = 0
         for neuronId in modelDict[layerId]["neuron"]:
           acc[0] = modelDict[layerId]["neuron"][neuronId]["bias"]
           for weightValue,ifmapValue in zip(modelDict[layerId]["neuron"][neuronId]["weights"],flatten_output):
             acc[0] = float(acc[0]) + float(weightValue*ifmapValue)
           output[idx] = acc[0]
           idx = idx + 1

     if testLabel[testCase] == output.index(max(output)):
       cont_match = cont_match + 1

