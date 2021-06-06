# Migration `20210108193022-usdprice-tofloat`

This migration has been generated by rahuldamodar94 at 1/8/2021, 7:30:22 PM.
You can check out the [state of the schema](./schema.prisma) after the migration.

## Database Steps

```sql
ALTER TABLE "public"."orders" DROP COLUMN "usd_price",
ADD COLUMN "usd_price" Decimal(65,30)   ;
```

## Changes

```diff
diff --git schema.prisma schema.prisma
migration 20210107210441-added-usd-price..20210108193022-usdprice-tofloat
--- datamodel.dml
+++ datamodel.dml
@@ -3,9 +3,9 @@
 }
 datasource db {
   provider = "postgresql"
-  url = "***"
+  url      = env("DATABASE_URL")
 }
 model bids {
   active    Boolean? @default(true)
@@ -94,9 +94,9 @@
   id             Int             @default(autoincrement()) @id
   maker_address  Int?
   min_price      String
   price          String
-  usd_price            String?
+  usd_price      Float?
   signature      String?
   status         Int?            @default(0)
   taker_address  Int?
   taker_amount   String?
```

