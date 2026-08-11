## How To Fix Your Save File After Exporting/Reimporting it With Gen1Recomp
So, you exported your save file from Gen1Recomp, re-imported it, and now Green, Yellow, or both are gone from your game.
First off, there's nothing to panic about. This is just the nature of how things work with this engine and this mod.
Second, this isn't impossible to fix. All you need is a few seconds and a text editor that can open a .lua file. I'm using kate, which is the ext editor that comes bundled with CachyOS, but if you poke around on Google, I'm sure that you can find a text editor that works for you and your system.
Third, you will have to do this **every time** you export/import a save with this mod.

Let's get into fixing your save:

### Step 1:
Go ahead and import your save. For this tutorial, I'm going to load it into Slot 2 in Gen1Recomp

### Step 2:
Find where your save files in Gen1Recomp are stored. If its in portable mode, it should be in the same folder as the executable. If not, then check the wiki to see where your system put the saves.
This is **NOT** the same folder as where the game exports .sav files to. The game loads .lua files for saves, and they are titled slotX.lua (with X being whichever slot number the save is).

### Step 3:
Find an old save that has had Green and/or Yellow selected. In this case, that mod for me is in Slot 1.

### Step 4:
Open that file in a text editor, and look for this chunk of text:
<br>
<img width="800" height="500" alt="step 4a" src="https://github.com/user-attachments/assets/e6f04a17-8cb4-405a-907e-08c1922fe3f8" />
<img width="800" height="500" alt="step 4b" src="https://github.com/user-attachments/assets/b23c591a-4deb-4e46-a744-11252fe1ccc4" />
<br> It starts at **meta = {** and ends at the **},** above "money".
Highlight that chunk of text and CTRL + C it.

### Step 5:
Open the save that needs to be fixed, and look for this chunk of text:
<br>
<img width="800" height="500" alt="step 5" src="https://github.com/user-attachments/assets/90ba9ee1-8b9c-40a1-8597-64b15b12458d" />
<br> Then highlight that text like in the image above

### Step 6:
Paste the stuff you copied from the good save, replacing the stuff you just highlighted.
Press CTRL + S (or whatever you need to do) to save.

### Step 7:
Open that save slot in Gen1Recomp, and Green/Yellow will be back!


## Help! I didn't save a copy of my save file!
Don't worry. We at Transwarp Technologies have got you covered. Just look for the **Copy To Fix Save File.md** file in the repo. 
<br> Edit it as needed, and paste that into the save file you need to fix just as if you had copied it from a different save, and follow the instructions as normal.
