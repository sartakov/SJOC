#!/usr/bin/python3

# TODO:unify trapezoid and freeform (position_type)

import zipfile
import xml.etree.ElementTree as ET
import argparse
import os

def extract_nosecone_values(root):
    """
    Extracts specified values from the <nosecone> element in the XML tree.
    """
    nosecone = root.find('.//nosecone')
    if nosecone is None:
        raise ValueError("No <nosecone> element found in the XML.")
    
    values = {
        'length': nosecone.findtext('length', default=''),
        'thickness': nosecone.findtext('thickness', default=''),
        'shape': nosecone.findtext('shape', default=''),
        'shapeclipped': nosecone.findtext('shapeclipped', default='false'),
        'shapeparameter': nosecone.findtext('shapeparameter', default='0.5'),
        'aftradius': nosecone.findtext('aftradius', default=''),
        'aftshoulderradius': nosecone.findtext('aftshoulderradius', default=''),
        'aftshoulderlength': nosecone.findtext('aftshoulderlength', default=''),
        'aftshoulderthickness': nosecone.findtext('aftshoulderthickness', default=''),
        'aftshouldercapped': nosecone.findtext('aftshouldercapped', default=''),
        'isflipped': nosecone.findtext('isflipped', default=''),
    }

    # Convert numeric values to float and multiply by 1000
    for key in values:
        if key != 'shape' and key != 'shapeparameter' and values[key].replace('.', '', 1).isdigit():
            values[key] = str(float(values[key]) * 1000)
    
    values['shape'] = f'"{values["shape"]}"'
    values['shapeclipped'] = f'{values["shapeclipped"]} /* ignored */'

    return values

def extract_trapezoidfinset_values(subcomponent):
    """
    Extracts thickness and height values from a <trapezoidfinset> subcomponent.
    """
    # Find the position element and get the type attribute
    position_element = subcomponent.find('position')
    position_type = f'"{position_element.get("type", "")}"' if position_element is not None else '""'

    trapezoidfinset_values = {
        'trapezoidfinset_height': subcomponent.findtext('height', default=''),
        'trapezoidfinset_sweeplength': subcomponent.findtext('sweeplength', default=''),
        'trapezoidfinset_tipchord': subcomponent.findtext('tipchord', default=''),
        'trapezoidfinset_rootchord': subcomponent.findtext('rootchord', default=''),
        'trapezoidfinset_filletradius': subcomponent.findtext('filletradius', default=''),
        'trapezoidfinset_cant': subcomponent.findtext('cant', default=''),
        'trapezoidfinset_crosssection': subcomponent.findtext('crosssection', default=''),
        'trapezoidfinset_thickness': subcomponent.findtext('thickness', default=''),
        'trapezoidfinset_position_type': position_type,
        'trapezoidfinset_position': subcomponent.findtext('position', default=''),
        'trapezoidfinset_axialoffset': subcomponent.findtext('axialoffset', default=''),
        'trapezoidfinset_rotation': subcomponent.findtext('rotation', default=''),
        'trapezoidfinset_angleoffset': subcomponent.findtext('angleoffset', default=''),
        'trapezoidfinset_radiusoffset': subcomponent.findtext('radiusoffset', default=''),
        'trapezoidfinset_fincount': subcomponent.findtext('fincount', default=''),
        'trapezoidfinset_instancecount': subcomponent.findtext('instancecount', default=''),
    }
    
    # Convert numeric values to float and multiply by 1000
    for key in trapezoidfinset_values:
        if key not in ['trapezoidfinset_fincount', 'trapezoidfinset_instancecount', 'trapezoidfinset_position'] and trapezoidfinset_values[key].replace('.', '', 1).isdigit():
            trapezoidfinset_values[key] = str(float(trapezoidfinset_values[key]) * 1000)

    trapezoidfinset_values['trapezoidfinset_crosssection'] = f'"{trapezoidfinset_values["trapezoidfinset_crosssection"]}"'

    return trapezoidfinset_values


def extract_launchlug_values(subcomponent):

#echo(str("                    <angleoffset method=\"relative\">-12.0</angleoffset>                                  "));                                       
#echo(str("                    <axialoffset method=\"top\">0.0075</axialoffset>                                      "));

    """
    Extracts length and diameter values from a <launchlug> subcomponent.
    """
    launchlug_values = {
        'launchlug_instancecount': subcomponent.findtext('instancecount', default=''),
        'launchlug_instanceseparation': subcomponent.findtext('instanceseparation', default=''),
        'launchlug_length': subcomponent.findtext('length', default=''),
        'launchlug_radius': subcomponent.findtext('radius', default=''),
        'launchlug_position': subcomponent.findtext('position', default=''), #TODO: <position type="bottom"
        'launchlug_thickness': subcomponent.findtext('thickness', default=''),
    }
    
    # Convert numeric values to float and multiply by 1000
    for key in launchlug_values:
        if key != 'launchlug_instancecount' and launchlug_values[key].replace('.', '', 1).isdigit():
            launchlug_values[key] = str(float(launchlug_values[key]) * 1000)
    
    return launchlug_values

def extract_freeformfinset_values(subcomponent):
    """
    Extracts values from a <freeformfinset> subcomponent.
    """
    values = {
        'freeformfinset_instancecount': subcomponent.findtext('instancecount', default=''),
        'freeformfinset_fincount': subcomponent.findtext('fincount', default=''),
        'freeformfinset_radiusoffset': subcomponent.findtext('radiusoffset', default=''),
        'freeformfinset_angleoffset': subcomponent.findtext('angleoffset', default=''),
        'freeformfinset_rotation': subcomponent.findtext('rotation', default=''),
        'freeformfinset_axialoffset': subcomponent.findtext('axialoffset', default=''),
        'freeformfinset_position': subcomponent.find('position').get('type', '') if subcomponent.find('position') is not None else '',
        'freeformfinset_thickness': subcomponent.findtext('thickness', default=''),
        'freeformfinset_crosssection': subcomponent.findtext('crosssection', default=''),
        'freeformfinset_cant': subcomponent.findtext('cant', default=''),
        'freeformfinset_tabheight': subcomponent.findtext('tabheight', default=''),
        'freeformfinset_tablength': subcomponent.findtext('tablength', default=''),
        'freeformfinset_tabposition_front': subcomponent.find('tabposition[@relativeto="front"]').text if subcomponent.find('tabposition[@relativeto="front"]') is not None else '',
        'freeformfinset_tabposition_top': subcomponent.find('tabposition[@relativeto="top"]').text if subcomponent.find('tabposition[@relativeto="top"]') is not None else '',
        'freeformfinset_filletradius': subcomponent.findtext('filletradius', default=''),
        'freeformfinset_radiusoffset_method': subcomponent.find('radiusoffset').get('method', '') if subcomponent.find('radiusoffset') is not None else '',
        'freeformfinset_angleoffset_method': subcomponent.find('angleoffset').get('method', '') if subcomponent.find('angleoffset') is not None else '',
        'freeformfinset_axialoffset_method': subcomponent.find('axialoffset').get('method', '') if subcomponent.find('axialoffset') is not None else '',
        'freeformfinset_finpoints': [
            {'x': point.get('x', ''), 'y': point.get('y', '')}
            for point in subcomponent.findall('finpoints/point')
        ]
    }

    # Convert numeric values to float and multiply by 1000
    for key in values:
        if key not in ['freeformfinset_instancecount', 'freeformfinset_fincount', 'freeformfinset_position', 'freeformfinset_crosssection', 
    			'freeformfinset_tabposition_front', 'freeformfinset_tabposition_top', 'freeformfinset_radiusoffset_method', 'freeformfinset_angleoffset_method', 
    			'freeformfinset_axialoffset_method', 'freeformfinset_angleoffset', 'freeformfinset_rotation', 'freeformfinset_finpoints']:
            try:
                values[key] = str(float(values[key]) * 1000)
            except ValueError:
                pass

    # Enclose certain string values in double quotes
    values['freeformfinset_crosssection'] = f'"{values["freeformfinset_crosssection"]}"'
    values['freeformfinset_position'] = f'"{values["freeformfinset_position"]}"'
    values['freeformfinset_tabposition_front'] = f'"{values["freeformfinset_tabposition_front"]}"'
    values['freeformfinset_tabposition_top'] = f'"{values["freeformfinset_tabposition_top"]}"'
    values['freeformfinset_radiusoffset_method'] = f'"{values["freeformfinset_radiusoffset_method"]}"'
    values['freeformfinset_angleoffset_method'] = f'"{values["freeformfinset_angleoffset_method"]}"'
    values['freeformfinset_axialoffset_method'] = f'"{values["freeformfinset_axialoffset_method"]}"'

    values['freeformfinset_finpoints'] = ', '.join([f"[{item['x']}, {item['y']}]" for item in values['freeformfinset_finpoints']])

    values['freeformfinset_finpoints'] = f'[{values["freeformfinset_finpoints"]}]'

    return values


def extract_bodytube_values(root, base_filename):
    """
    Extracts specified values from all <bodytube> elements in the XML tree and writes them to separate .scad files.
    """
    bodytubes = root.findall('.//bodytube')
    if not bodytubes:
        raise ValueError("No <bodytube> elements found in the XML.")
    
    for index, bodytube in enumerate(bodytubes):
        values = {
            'length': bodytube.findtext('length', default=''),
            'thickness': bodytube.findtext('thickness', default=''),
            'radius': bodytube.findtext('radius', default='')
        }
        
        # Convert numeric values to float and multiply by 1000
        for key in values:
            if values[key].replace('.', '', 1).isdigit():
                values[key] = str(float(values[key]) * 1000)
        
        # Extract motormount values
        motormount = bodytube.find('.//motormount')
        if motormount is not None:
            overhang = motormount.findtext('overhang', default='')
            if overhang.replace('.', '', 1).isdigit():
                overhang = str(float(overhang) * 1000)
            values['motor_overhang'] = overhang
            
            motor = motormount.find('.//motor')
            if motor is not None:
                motor_diameter = motor.findtext('diameter', default='')
                motor_length = motor.findtext('length', default='')
                if motor_diameter.replace('.', '', 1).isdigit():
                    motor_diameter = str(float(motor_diameter) * 1000)
                if motor_length.replace('.', '', 1).isdigit():
                    motor_length = str(float(motor_length) * 1000)
                values['motor_diameter'] = motor_diameter
                values['motor_length'] = motor_length
        
        # Initialize lists for subcomponents
        launchlug_values_list = []
        trapezoidfinset_values_list = []
        freeformfinset_values_list = []
        
        # Extract subcomponents values
        subcomponents = bodytube.find('.//subcomponents')
        if subcomponents is not None:
            for subcomponent in subcomponents:
                tag = subcomponent.tag
                if tag == 'launchlug':
                    launchlug_values = extract_launchlug_values(subcomponent)
                    launchlug_values_list.append(launchlug_values)
                elif tag == 'trapezoidfinset':
                    trapezoidfinset_values = extract_trapezoidfinset_values(subcomponent)
                    trapezoidfinset_values_list.append(trapezoidfinset_values)
                elif tag == 'freeformfinset':
                    freeformfinset_values = extract_freeformfinset_values(subcomponent)
                    freeformfinset_values_list.append(freeformfinset_values)



        values['launchlug_total'] = len(launchlug_values_list)
        values['trapezoidfinset_total'] = len(trapezoidfinset_values_list)
        values['freeformfinset_total'] = len(freeformfinset_values_list)
        
        # Convert lists to arrays
        if launchlug_values_list:
            for key in launchlug_values_list[0].keys():
                values[key] = [launchlug_values[key] for launchlug_values in launchlug_values_list]
        
        if trapezoidfinset_values_list:
            for key in trapezoidfinset_values_list[0].keys():
                values[key] = [trapezoidfinset_values[key] for trapezoidfinset_values in trapezoidfinset_values_list]

        if freeformfinset_values_list:
            for key in freeformfinset_values_list[0].keys():
                values[key] = [freeformfinset_values[key] for freeformfinset_values in freeformfinset_values_list]

        
        # Write the bodytube .scad files
        bodytube_scad_filename = f"{base_filename}_bodytube_{index + 1}.scad"
        write_bodytube(bodytube_scad_filename, values)

def write_nosecone(scad_filename, values):
    """
    Writes the extracted values to a .scad file.
    """
    with open(scad_filename, 'w') as file:
        file.write(f"include <../modules_ork.scad>\n\n")
        for key, value in values.items():
            file.write(f"{key} = {value};\n")
        file.write(f"\nnosecone_with_shoulders();\n")

def write_bodytube(scad_filename, values):
    """
    Writes the extracted values to a .scad file.
    """
    with open(scad_filename, 'w') as file:
        file.write("include <../modules_ork.scad>\n\n")
        
        for key, value in values.items():
            if isinstance(value, list):
                file.write(f"{key} = [{', '.join(map(str, value))}];\n")
            else:
                file.write(f"{key} = {value};\n")

        file.write("\nbodytube_with_fins();\n")


def main(zip_path, xml_filename):
    # Open the zip file
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        # Extract the specific XML file
        with zip_ref.open(xml_filename) as xml_file:
            # Parse the XML file
            tree = ET.parse(xml_file)
            root = tree.getroot()
            
            # Extract nosecone values
            values = extract_nosecone_values(root)
            scad_filename = zip_path.replace('.ork', '_nosecone.scad')
            write_nosecone(scad_filename, values)

            # Extract bodytube values and write to files
            base_filename = os.path.splitext(zip_path)[0]
            extract_bodytube_values(root, base_filename)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process a zipped XML file and extract nosecone values.')
    parser.add_argument('zip_path', help='Path to the zip file containing the XML.')
    
    args = parser.parse_args()
    
    main(args.zip_path, "rocket.ork")
