from pathlib import Path
import pandas as pd


RAW_DIR = Path("data/raw")


def profile_csv(file_path: Path) -> None:
    print("\n" + "=" * 80)
    print(f"FILE: {file_path.name}")
    print("=" * 80)

    try:
        df = pd.read_csv(
            file_path,
            encoding="utf-8"
        )
    except UnicodeDecodeError:
        df = pd.read_csv(
            file_path,
            encoding="ISO-8859-1"
        )

    print(f"Rows    : {len(df):,}")
    print(f"Columns : {len(df.columns)}")

    print("\nColumns:")
    for col in df.columns:
        print(f"  - {col}")

    print("\nData types:")
    print(df.dtypes.to_string())

    print("\nMissing values:")
    print(df.isnull().sum().to_string())

    print("\nFirst 3 rows:")
    print(df.head(3).to_string(index=False))


def main() -> None:
    csv_files = sorted(RAW_DIR.glob("*.csv"))

    if not csv_files:
        print(f"No CSV files found in: {RAW_DIR.resolve()}")
        return

    print(f"Found {len(csv_files)} CSV file(s).")

    for file_path in csv_files:
        profile_csv(file_path)


if __name__ == "__main__":
    main()