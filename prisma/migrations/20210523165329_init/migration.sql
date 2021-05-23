-- CreateTable
CREATE TABLE "bids" (
    "active" BOOLEAN DEFAULT true,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "orders_id" INTEGER NOT NULL,
    "price" TEXT NOT NULL,
    "signature" TEXT NOT NULL,
    "status" INTEGER DEFAULT 0,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "users_id" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "active" BOOLEAN DEFAULT true,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" TEXT,
    "id" SERIAL NOT NULL,
    "img_url" TEXT,
    "name" TEXT NOT NULL,
    "name_lowercase" TEXT NOT NULL DEFAULT E'',
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "url" TEXT,
    "type" TEXT DEFAULT E'ERC721',
    "tokenURI" TEXT,
    "isOpenseaCompatible" BOOLEAN DEFAULT false,
    "isMetaTx" BOOLEAN DEFAULT false,
    "disabled" BOOLEAN DEFAULT false,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categoriesaddresses" (
    "active" BOOLEAN DEFAULT true,
    "address" TEXT NOT NULL,
    "ethereum_address" TEXT NOT NULL,
    "categories_id" INTEGER NOT NULL,
    "chain_id" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("address","chain_id")
);

-- CreateTable
CREATE TABLE "tokens" (
    "token_id" TEXT NOT NULL,
    "categories_id" INTEGER NOT NULL,
    "image_url" TEXT,
    "description" TEXT,
    "external_url" TEXT,
    "name" TEXT,
    "name_lowercase" TEXT DEFAULT E'',
    "attributes" TEXT,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("token_id","categories_id")
);

-- CreateTable
CREATE TABLE "erc20tokens" (
    "active" BOOLEAN DEFAULT true,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "decimal" INTEGER NOT NULL,
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "symbol" TEXT NOT NULL,
    "isMetaTx" BOOLEAN NOT NULL DEFAULT true,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "market_price" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "erc20tokensaddresses" (
    "active" BOOLEAN DEFAULT true,
    "address" TEXT NOT NULL,
    "chain_id" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "token_id" INTEGER NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "favourites" (
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "users_id" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "orders" (
    "active" BOOLEAN DEFAULT true,
    "chain_id" TEXT NOT NULL,
    "categories_id" INTEGER NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "erc20tokens_id" INTEGER NOT NULL,
    "expiry_date" TIMESTAMP(3),
    "id" SERIAL NOT NULL,
    "maker_address" INTEGER,
    "min_price" TEXT NOT NULL,
    "price" TEXT NOT NULL,
    "price_per_unit" TEXT,
    "min_price_per_unit" TEXT,
    "quantity" TEXT,
    "token_type" TEXT DEFAULT E'ERC721',
    "usd_price" DOUBLE PRECISION,
    "signature" TEXT,
    "status" INTEGER DEFAULT 0,
    "taker_address" INTEGER,
    "taker_amount" TEXT,
    "maker_amount" TEXT,
    "tokens_id" TEXT NOT NULL,
    "txhash" TEXT,
    "type" TEXT NOT NULL,
    "buyer" INTEGER,
    "seller" INTEGER,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "views" INTEGER DEFAULT 0,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "active" BOOLEAN DEFAULT true,
    "address" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admins" (
    "active" BOOLEAN DEFAULT true,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "read" BOOLEAN NOT NULL DEFAULT false,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "message" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT E'ORDER',
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "order_id" INTEGER NOT NULL,
    "usersId" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assetmigrate" (
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" SERIAL NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT NOT NULL,
    "txhash" TEXT NOT NULL,
    "exit_txhash" TEXT,
    "block_number" TEXT,
    "message" TEXT,
    "token_array" TEXT[],
    "users_id" INTEGER NOT NULL,
    "categories_id" INTEGER NOT NULL,
    "status" INTEGER DEFAULT 0,

    PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "categories.name_unique" ON "categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "erc20tokens.symbol_unique" ON "erc20tokens"("symbol");

-- CreateIndex
CREATE UNIQUE INDEX "erc20tokensaddresses.address_unique" ON "erc20tokensaddresses"("address");

-- CreateIndex
CREATE UNIQUE INDEX "users.address_unique" ON "users"("address");

-- CreateIndex
CREATE UNIQUE INDEX "admins.username_unique" ON "admins"("username");

-- CreateIndex
CREATE UNIQUE INDEX "assetmigrate.txhash_unique" ON "assetmigrate"("txhash");

-- CreateIndex
CREATE UNIQUE INDEX "assetmigrate.exit_txhash_unique" ON "assetmigrate"("exit_txhash");

-- AddForeignKey
ALTER TABLE "erc20tokensaddresses" ADD FOREIGN KEY ("token_id") REFERENCES "erc20tokens"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favourites" ADD FOREIGN KEY ("order_id") REFERENCES "orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favourites" ADD FOREIGN KEY ("users_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categoriesaddresses" ADD FOREIGN KEY ("categories_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD FOREIGN KEY ("categories_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD FOREIGN KEY ("tokens_id", "categories_id") REFERENCES "tokens"("token_id", "categories_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD FOREIGN KEY ("erc20tokens_id") REFERENCES "erc20tokens"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD FOREIGN KEY ("buyer") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD FOREIGN KEY ("seller") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bids" ADD FOREIGN KEY ("orders_id") REFERENCES "orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bids" ADD FOREIGN KEY ("users_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD FOREIGN KEY ("order_id") REFERENCES "orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD FOREIGN KEY ("usersId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assetmigrate" ADD FOREIGN KEY ("users_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assetmigrate" ADD FOREIGN KEY ("categories_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tokens" ADD FOREIGN KEY ("categories_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;
