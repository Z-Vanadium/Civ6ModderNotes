# FILE:     modinfo_combiner.py
# AUTHOR:   Vanadium
# PURPOSE:  Combine mods' modinfo
#           default load order depends on path alpha order
#           A/.../files.xml loads earlier than Z/.../files.xml

from bs4 import BeautifulSoup
import xml.etree.ElementTree as ET
import os
import re

FILE_NAME       = 'combiner_test'
MOD_ID          = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
MOD_VERSION     = '1'
MOD_NAME        = 'test mod combiner name'
MOD_DESCRIPTION = 'test mod combiner description'
MAX_MOD_CNT     = 99
AUTHORS         = [
    'Vanadium',
]

# rename all *.modinfo to files.xml
def modinfo_renamer():
    current_path = os.getcwd()
    for root, dirs, files in os.walk(current_path):
        for file in files:
            if not file.startswith(FILE_NAME) and file.endswith('.modinfo'):                    
                modinfo_path = os.path.join(root, file)
                new_modinfo_path = os.path.join(root, "files.xml")
                os.rename(modinfo_path, new_modinfo_path)
                print(f'Renamed {modinfo_path} to {new_modinfo_path}')
    return

# combine all files.xml into 
def modinfo_combiner():
    new_mod_dict = {}
    mod_cnt = 0
    author_dict = {}
    special_thanks_dict = {}
    files_dict = {}
    extra_dependencies = {}
    mod_dirs = []

    current_path = os.getcwd()
    for root, dirs, files in os.walk(current_path):
        for file in files:
            if file.endswith('files.xml'):                    
                modinfo_path = os.path.join(root, file)
                mod_dirs.append(os.path.relpath(root, current_path).replace('\\', '/'))
    print(mod_dirs)
    # return

    for _ in AUTHORS:
        author_dict[_] = 1
    for mod in mod_dirs:
        modinfo_path = os.path.join(mod, "files.xml")
        print(modinfo_path)
        if os.path.exists(modinfo_path):
            with open(modinfo_path, 'r', encoding='utf-8') as file:
                data = file.read()
            Bs_data = BeautifulSoup(data, "xml")
            file_tags = Bs_data.find_all("File")            
            # Append the string in each File tag with the mod folder name
            for b in file_tags:
                if b.string in files_dict:
                    print(f'same file name used in {mod} and {files_dict[b.string]}: {b.string}')
                b.string = f'{mod}/{b.string}'

            lua_replace_tags = Bs_data.find_all("LuaReplace")
            for b in lua_replace_tags:
                print(f'LuaReplace tag: {b}')
                b.string = f'{mod}/{b.string}'

            for b in file_tags:
                files_dict[b.string] = mod
            for b in lua_replace_tags:
                files_dict[b.string] = mod

            load_order_tags = Bs_data.find_all("LoadOrder")
            # Append the string in each File tag with the mod folder name
            for b in load_order_tags:
                b.string = f'{MAX_MOD_CNT-mod_cnt}{b.string}'
                
            author_tags = Bs_data.find_all("Authors")
            for tag in author_tags:
                delimiters = r'[;,\s]+'
                for author in re.split(delimiters, tag.string):
                    special_thanks_dict[author] = 1
                    
            special_thanks_tags = Bs_data.find_all("SpecialThanks")
            for tag in special_thanks_tags:
                delimiters = r'[;,\s]+'
                for author in re.split(delimiters, tag.string):
                    special_thanks_dict[author] = 1

            for b in Bs_data.find('Mod'):
                if b.name == 'Properties' or b.name == 'Dependencies' or b.name == None:
                    continue
                if b.name not in new_mod_dict:
                    new_mod_dict[b.name] = ''
                new_mod_dict[b.name] = new_mod_dict[b.name] + str(b) + '\n'

        mod_cnt += 1

    sorted_authors = sorted(author_dict.keys(), key=lambda item: item)
    sorted_special_thanks = sorted(special_thanks_dict.keys(), key=lambda item: item)

    extra_dependencies["1B28771A-C749-434B-9053-D1380C553DE9"] = "LOC_EXPANSION1_MOD_TITLE"
    extra_dependencies["4873eb62-8ccc-4574-b784-dda455e74e68"] = "LOC_EXPANSION2_MOD_TITLE"
    dependencies = ''
    for key, value in extra_dependencies.items():
        dependencies += f'    <Mod id="{key}" title="{value}"/>\n'

    new_file = f'''
<?xml version="1.0" encoding="UTF-8"?>
<Mod id="{MOD_ID}" version="{MOD_VERSION}">
  <Properties>
    <Name>{MOD_NAME}</Name>
    <Description>{MOD_DESCRIPTION}</Description>
    <Authors>{', '.join(sorted_authors)} (alphabetical order)</Authors>
    <SpecialThanks>{', '.join(sorted_special_thanks)} (alphabetical order)</SpecialThanks>
    <CompatibleVersions>1.2,2.0</CompatibleVersions>
  </Properties>\n'''
    new_file += f'<Dependencies>\n{dependencies}</Dependencies>\n'
    for key, value in new_mod_dict.items():
        print(key)
        new_file += ''.join(value).replace(f'</{key}>\n<{key}>', '')
    new_file += '</Mod>'

    with open(f'{FILE_NAME}.modinfo', 'w', encoding='utf-8') as file:
        file.write(new_file)



    return

if __name__ == '__main__':
    modinfo_renamer()
    modinfo_combiner()
