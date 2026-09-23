from pathlib import Path
import pandas as pd


RAW_DIR = Path("data/raw")


def read_csv(file_path):
    try:
        return pd.read_csv(file_path, encoding="utf-8")
    except UnicodeDecodeError:
        return pd.read_csv(file_path, encoding="ISO-8859-1")


def check_key(df, column, table_name):
    total = len(df)
    unique = df[column].nunique()
    duplicates = total - unique

    print(f"\n[{table_name}] {column}")
    print(f"Rows       : {total:,}")
    print(f"Unique     : {unique:,}")
    print(f"Duplicates : {duplicates:,}")


def check_orphans(child_df, child_col, parent_df, parent_col, relationship):
    child_values = set(child_df[child_col].dropna())
    parent_values = set(parent_df[parent_col].dropna())

    orphan_values = child_values - parent_values

    print(f"\n[{relationship}]")
    print(f"Orphan values: {len(orphan_values)}")

    if orphan_values:
        print("Examples:", list(orphan_values)[:10])


def main():
    customer = read_csv(RAW_DIR / "Customer.csv")
    employee = read_csv(RAW_DIR / "Employee.csv")
    order_details = read_csv(RAW_DIR / "OrderDetails.csv")
    orders = read_csv(RAW_DIR / "Orders.csv")
    product = read_csv(RAW_DIR / "Product.csv")
    region = read_csv(RAW_DIR / "Region.csv")
    warehouse = read_csv(RAW_DIR / "Warehouse.csv")

    print("=" * 80)
    print("PRIMARY KEY VALIDATION")
    print("=" * 80)

    check_key(customer, "CustomerID", "Customer")
    check_key(employee, "EmployeeID", "Employee")
    check_key(order_details, "OrderDetailsID", "OrderDetails")
    check_key(orders, "OrderID", "Orders")
    check_key(product, "ProductID", "Product")
    check_key(region, "RegionID", "Region")
    check_key(warehouse, "WarehouseID", "Warehouse")

    print("\n" + "=" * 80)
    print("FOREIGN KEY VALIDATION")
    print("=" * 80)

    check_orphans(
        orders,
        "CustomerID",
        customer,
        "CustomerID",
        "Orders.CustomerID -> Customer.CustomerID"
    )

    check_orphans(
        order_details,
        "OrderID",
        orders,
        "OrderID",
        "OrderDetails.OrderID -> Orders.OrderID"
    )

    check_orphans(
        order_details,
        "ProductID",
        product,
        "ProductID",
        "OrderDetails.ProductID -> Product.ProductID"
    )

    check_orphans(
        employee,
        "WarehouseID",
        warehouse,
        "WarehouseID",
        "Employee.WarehouseID -> Warehouse.WarehouseID"
    )

    check_orphans(
        warehouse,
        "RegionID",
        region,
        "RegionID",
        "Warehouse.RegionID -> Region.RegionID"
    )

    print("\n" + "=" * 80)
    print("DATE RANGES")
    print("=" * 80)

    orders["OrderDate"] = pd.to_datetime(
        orders["OrderDate"],
        errors="coerce"
    )

    employee["EmployeeHireDate"] = pd.to_datetime(
        employee["EmployeeHireDate"],
        errors="coerce"
    )

    print(
        "Order Date:",
        orders["OrderDate"].min(),
        "to",
        orders["OrderDate"].max()
    )

    print(
        "Employee Hire Date:",
        employee["EmployeeHireDate"].min(),
        "to",
        employee["EmployeeHireDate"].max()
    )

    print("\n" + "=" * 80)
    print("ORDER STATUS")
    print("=" * 80)

    print(order_details["OrderStatus"].value_counts(dropna=False))

    print("\n" + "=" * 80)
    print("PRODUCT CATEGORIES")
    print("=" * 80)

    print(product["CategoryName"].value_counts(dropna=False))

    print("\nValidation completed.")


if __name__ == "__main__":
    main()