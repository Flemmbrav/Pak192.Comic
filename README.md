# Pak192.Comic
![logo](pakset/UI/128/images/big_logo_25_years.png)

Pakset and theme for Simutrans

## Run the pakset

0. Install Simutrans
	1. Since this is a nightly pakset, it may not run with the Simutrans version you have already installed. Please go to https://www.simutrans-forum.de/nightly/ for the most recent Simutrans Nightlies.
	Note: Nightlies do not replace stable versions, especially if you intend to play a long game!
1. Get yourself the pakset from [the release page.](https://github.com/Flemmbrav/Pak192.Comic/releases)
	1. Additionally you can download an addonset from the same page. This addon set does not include all addons there are.
	2. Or download yourself an old version from [the forum.](https://forum.simutrans.com/index.php?board=120.0)
2. Unzip the pakset.
3. Copy the unzipped pakset in your Simutrans game folder.
	1. If you did download the addon set as well, put them in your addon folder in your user directionary. On Windows this folder appears at C:\Users\[User]\Documents\Simutrans\addons
	2. Remane the new folder in the addon directionary to the same name that you use for the folder in the game file directionary.
4. Start Simutrans the way you did before, and you'll see a menu asking you for a pakset to run. Select the new added folder to run this pakset.
	1. If you did install the addons as well, there should be a button to start the game with them as well.
5. Happy playing.

## Run the theme

1. Get yourself the theme from [the release page.](https://github.com/Flemmbrav/Pak192.Comic/releases)
2. Unzip the theme.
3. Copy the unzipped theme in the theme folder inside of your Simutrans game folder.
4. Start Simutrans the way you did before, open the settings, select `Display Settings` , `Select a theme for display` and `pak192.comic`
5. Happy playing.

## Manual compile

1. Clone this repository using `git clone https://github.com/Flemmbrav/Pak192.Comic.git`
2. Switch to Pak192.Comic directory
3. Get yourself a new makeobj and put it in this folder.
3. Start compile with preconfigured compiler :
	1. ~~To compile under windows, run the **`COMPILE.ps1`** via PowerShell.~~
	2. To compile under unix:
        - run the **`DatConverter.sh`**.
        - run the **`COMPILE_Converted.sh`**.
4. Copy the folder named **compiled_converted** in your usual Simutrans game folder and rename it to **Pak192.Comic**.
5. Start Simutrans the way you did before, and you'll see a menu asking you for a pakset to run. Select **Pak192.Comic** to run this pakset.
6. Happy playing.

The same progress has to be done to compile the addons or the theme as well. Just use the **`COMPILE_Converted_AddOns.sh`** or the **`COMPILE_THEME.sh`** instead.
You can also compile a pakset with already included addons by running the **`COMPILE_Converted_Serverset.sh`**.instead of **`COMPILE_Converted.sh`**..

## Bug reports

Feel free to create a issue to this repository when you encountered any technical errors.

## Contribute

Yes this is a thing!
Pak192.Comic is open source (duh), freely adjustable and auto compiles from github actions. That means, you could just clone the repository, do some funky changes and have github build your very own version without doing a lot for it. There's no weird encoding, no encrypted values, nothing. If you go to the dat file for your favourite steam engine and change the maximum speed from 100 to 2000, you just did that. It'll appear in the game just like that. Don't like coal power stations? Just get rid of them. Want to have a rainbow coloured subway? Just draw a rainbow on the image of your favourite subway train.
That's pretty cool, right?
But how about you share your funky changes with the rest of the world by adding them to this repository once they work out just fine. That way you could improve the world!… or well, at least this game.

In case you need help modifiing or contributing towateds the game, do not hesitate to ask for some.

## License

The content provided in this Git is published under CC-BY-SA 3.0, which is available in the `LICENSE.md`. If you want to credit the Git as a whole, or in case you can not identify the author, and only then, you may credit "pak192.comic team" as author.
