# Pak192.Comic

Pakset for Simutrans

## Run the pakset

0. Install Simutrans
0.1. In case you don't have it already, it's usually the best to get it from the official website: https://www.simutrans.com/en/download/
0.2. In case you want to go for a nightly here, check out [this page.](https://nightly.simutrans.com/en/)
1. Get yourself the pakset from [the release page.](https://github.com/Flemmbrav/Pak192.Comic/releases)
	1. Or get yourself a [freshly build nightly here.](https://github.com/Flemmbrav/Pak192.Comic/actions)
	2. Additionally you can download an addonset from the same page. This addon set does not include all addons there are.
2. Unzip the pakset
3. Copy the unzipped pakset in your Simutrans game folder.
	1. If you did download the addon set as well, put them in your addon folder in your user directionary. On Windows this folder appears at C:\Users\[User]\Documents\Simutrans\addons
	2. Remane the new folder in the addon directionary to the same name that you use for the folder in the game file directionary.
4. Start Simutrans the way you did before, and you'll see a menu asking you for a pakset to run. Select the new added folder to run this pakset.
	1. If you did install the addons as well, there should be a button to start the game with them as well.
5. Happy playing.

## Manual compile

1. Clone this repository using `git clone https://github.com/Flemmbrav/Pak192.Comic.git`
2. Switch to Pak192.Comic directory
3. Get yourself a new makeobj and put it in this folder.
3. Start compile with preconfigured compiler :
	1. To compile under windows, run the **`COMPILE.ps1`** via PowerShell.
	2. To compile under unix, run the **`COMPILE.sh`**.
4.Copy the folder named **compiled** in your usual Simutrans game folder and rename it to **Pak192.Comic**.
5. Start Simutrans the way you did before, and you'll see a menu asking you for a pakset to run. Select **Pak192.Comic** to run this pakset.
6. Happy playing.

The same progress has to be done to compile the addons as well. Just use the **`COMPILE_ADDONS.sh`** instead.

## Bug reports

Feel free to create a issue to this repository when you encountered any technical errors.