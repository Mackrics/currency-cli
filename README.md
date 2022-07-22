# currency-cli

A shell script which utilize the ECB api to convert currencies!


## Installation

```
git clone https://codeberg.org/mackan/currency-cli
cd currency-cli
chmod +x currency-cli.sh
```

## Usage

The program requires three arguments:

1. The amount you wish to convert (default is 1).
2. The currency you convert from (default is DKK).
3. The currency you convert to (default is SEK).
4. The date you wish to retrieve the conversion from (default is yesterday).

Example:
```
./currency-cli 10 EUR DKK 2022-07-21
```
