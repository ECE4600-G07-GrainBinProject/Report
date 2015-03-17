using System.Linq;
using System.IO;
using System.Collections;
using System.Collections.Generic;

using System;
using System.Text;

class put2string{

  static string[,] sp = new string[256, 3];

  public static void Main(string[] args)
  {
      string path = @"/root/vnaJ.3.1/export";


      if(Directory.Exists(path))
          ProcessDirectory(path);
      else
          Console.WriteLine("{0} is not a valid directory.", path);

      List<string> linesToWrite = new List<string>();
      for(int rowIndex = 0; rowIndex < 256; rowIndex++)
      {
          StringBuilder line = new StringBuilder();
          for(int colIndex = 0; colIndex < 3; colIndex++)
              line.Append(sp[rowIndex, colIndex]).Append("\t");
          linesToWrite.Add(line.ToString());
      }

      //export file to sp.dat
      System.IO.File.WriteAllLines(@"/root/grainbin/output/sp.dat", linesToWrite.ToArray());
  }

    // Process all files in the directory passed in
    public static void ProcessDirectory(string targetDirectory)
    {
        // Process the list of files found in the directory.
        string [] fileEntries = Directory.GetFiles(targetDirectory, "*.csv");
        if(fileEntries.Length == 0)
	    Console.WriteLine("ERROR! No files in directory to process");
	else{
		int count = 0;
        	foreach(string fileName in fileEntries)
        	{
           	  string dataID = Path.GetFileNameWithoutExtension(fileName);
             	  string tx = dataID.Substring(dataID.Length-4,2);
            	  string rx = dataID.Substring(dataID.Length-2,2);
            	  sp[count, 0] = tx;
           	  sp[count, 1] = rx;
           	  // Console.WriteLine("TX: {0}\tRX: {1}", sp[count, 0], sp[count, 1]);
          	  ProcessFile(fileName, count);
            	  count++;
        	}
	}
    }

    // Insert logic for processing found files here.
    public static void ProcessFile(string file, int count)
    {
        string[] lines = System.IO.File.ReadAllLines(file);
        string data = "";
        foreach(string line in lines.Skip(1)){

          string[] val = line.Split(',');

          double magdb = Convert.ToDouble(val[1]);
          double ph = Convert.ToDouble(val[2]);
          double mag = Math.Pow(10, magdb/20);
          double a = mag*Math.Cos(ph);
          double b = mag*Math.Sin(ph);

          data = string.Concat(data, string.Concat(a.ToString("N7") + "\t", b.ToString("N7") + "\t"));

          sp[count, 2] = data;
        }

        // Console.WriteLine("Processed file '{0}'.", file);
    }
  }
