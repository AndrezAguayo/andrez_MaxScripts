xmlFile = @"C:\_cache\temp\XML_Test\Sphere001.xml" --your xml file  
  
 dotnet.LoadAssembly "system.xml.dll" --source the xml parser into .net  
 xmlDoc = dotNetObject "System.Xml.XmlDocument" --create your xml parser object  
  
 xmlDoc.Load xmlFile --load the xml onto the parser object  
  
 header =  xmlDoc.item["Autodesk_Cache_File"] --this is how you pull an element section by name 