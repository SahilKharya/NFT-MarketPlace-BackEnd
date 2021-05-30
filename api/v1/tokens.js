const express = require("express");
const router = express.Router();
const { check, validationResult } = require("express-validator");
const TokenService = require("../services/tokens");
const tokenServiceInstance = new TokenService();
const userService = require("../services/user");
let userServiceInstance = new userService();
const categoryService = require("../services/category");
let categoryServiceInstance = new categoryService();
const OrderService = require("../services/order");
let orderServiceInstance = new OrderService();
let constants = require("../../config/constants");
const helper = require("../utils/helper");

/**
 * Token routes
 */

/**
 *  Gets all the token details on matic
 */

router.get(
  "/balance",
  [check("userId", "input a valid id").exists()],
  [check("chainId", "input a valid id").exists()],
  async (req, res) => {
    try {
      const errors = validationResult(req);

      if (!errors.isEmpty()) {
        return res
          .status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST)
          .json({ error: errors.array() });
      }

      let { userId, chainId } = req.body;
      let user = await userServiceInstance.getUser({ userId });
      console.log("user   " , user);

      if (!user) {
        return res.status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST).json({
          message: constants.MESSAGES.INPUT_VALIDATION_ERROR,
        });
      }

      let tokens = await tokenServiceInstance.getTokens({
        chainId,
        owner: user.address.toLowerCase(),
        userId,
      });
      console.log("tokens   " , tokens);

      if (tokens.nft_array.length > 0) {
        return res.status(constants.RESPONSE_STATUS_CODES.OK).json({
          message: constants.RESPONSE_STATUS.SUCCESS,
          data: tokens.nft_array,
          balances: tokens.balances,
          count: tokens.nft_array.length,
        });
      } else {
        return res.status(constants.RESPONSE_STATUS_CODES.OK).json({
          message: constants.RESPONSE_STATUS.SUCCESS,
        });
      }
    } catch (err) {
      console.log(err);
      return res
        .status(constants.RESPONSE_STATUS_CODES.INTERNAL_SERVER_ERROR)
        .json({ message: constants.MESSAGES.INTERNAL_SERVER_ERROR });
    }
  }
);


/**
 *  Adds a new token or updates existing token
 *  @params token_id type: String
 *  @params category_id type: Int
 *  @params description type: String
 *  @params image_url type: String
 *  @params external_url type: String
 *  @params name type: String
 *  @params attributes type: String
 */

router.post(
  "/",
  check("token_id", "A valid id is required").exists(),
  check("category_id", "A valid id is required").exists(),
  async (req, res) => {
    try {
      const errors = validationResult(req);

      if (!errors.isEmpty()) {
        return res
          .status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST)
          .json({ error: errors.array() });
      }

      let { token_id, category_id } = req.body;
      console.log(res.body)
      console.log(req.body)

      let category = await categoryServiceInstance.getCategory({
        categoryId: category_id,
      });

      if (!category) {
        return res
          .status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST)
          .json({ message: constants.MESSAGES.INPUT_VALIDATION_ERROR });
      }

      let tokenDetail = await tokenServiceInstance.getToken(req.body);

      if (!tokenDetail) {
        let token = await tokenServiceInstance.createToken(req.body);
        if (token) {
          return res
            .status(constants.RESPONSE_STATUS_CODES.OK)
            .json({ message: constants.RESPONSE_STATUS.SUCCESS, data: token });
        } else {
          return res
            .status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST)
            .json({ message: constants.RESPONSE_STATUS.FAILURE });
        }
      } else {
        let token = await tokenServiceInstance.updateToken(req.body);
        if (token) {
          return res
            .status(constants.RESPONSE_STATUS_CODES.OK)
            .json({ message: constants.RESPONSE_STATUS.SUCCESS, data: token });
        } else {
          return res
            .status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST)
            .json({ message: constants.RESPONSE_STATUS.FAILURE });
        }
      }
    } catch (err) {
      console.log(err);
      return res
        .status(constants.RESPONSE_STATUS_CODES.INTERNAL_SERVER_ERROR)
        .json({ message: constants.MESSAGES.INTERNAL_SERVER_ERROR });
    }
  }
);



/**
 *
 *  @params token_id type: String
 *  @params category_address type: Int
 *  @params chain_id type: String
 */
//here
router.get(
  "/detail",
  check("token_id", "A valid id is required").exists(),
  check("category_address", "A valid id is required").exists(),
  check("chain_id", "A valid id is required").exists(),
  async (req, res) => {
    try {
      let query = req.body;
      console.log("res1    ",req.body)
      const errors = validationResult(req);

      if (!errors.isEmpty()) {
        return res
          .status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST)
          .json({ error: errors.array() });
      }
      console.log("13    ",query.category_address)
      console.log("1333    ",query.chain_id)

      let categoryDetail = await categoryServiceInstance.getCategoryByAddress({
        categoryAddress: helper.toChecksumAddress(query.category_address),
        chainId: query.chain_id,
      });
      console.log("categoryDetail    ",categoryDetail)

      if (!categoryDetail) {
        return res
          .status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST)
          .json({ message: constants.MESSAGES.INPUT_VALIDATION_ERROR });
      } else {
        let category = await categoryServiceInstance.getCategory({
          categoryId: categoryDetail.categories_id,
        });
        console.log("get category    ",category)

        let token = await tokenServiceInstance.getToken({
          token_id: query.token_id,
          category_id: category.id,
        });

        let tokenMetadata = await helper.fetchMetadata(
          helper.toChecksumAddress(query.category_address),
          query.token_id
        );
        console.log("tokenMetadata   ",tokenMetadata)

        let metadata;
        if (tokenMetadata && tokenMetadata.metadata && tokenMetadata.metadata !== "{}") {
          console.log("if   token   ")
          metadata = JSON.parse(tokenMetadata.metadata);
        } else {
          if (category.tokenURI) {
          console.log("else if   token   ", category)

            metadata = await helper.fetchMetadataFromTokenURI(
              category.tokenURI + query.token_id
            );
          } else {
          console.log("else   token   ", category)

            if (tokenMetadata.token_uri) {
          console.log("else  if 2 token   ")

              metadata = await helper.fetchMetadataFromTokenURI(
                tokenMetadata.token_uri
              );
            }
          }
        }
        console.log("token   ",token)
        console.log("metadata   ",metadata)

        if (!token) {
          token = await tokenServiceInstance.createToken({
            token_id: query.token_id,
            category_id: category.id,
            name: metadata ? metadata.name : "",
            description: metadata ? metadata.description : "",
            image_url: metadata ? metadata.image : "",
            external_url: metadata ? metadata.external_url : "",
            attributes: metadata ? JSON.stringify(metadata.attributes) : "",
          });
        } else {
          token = await tokenServiceInstance.updateToken({
            token_id: query.token_id,
            category_id: category.id,
            name: metadata ? metadata.name : "",
            description: metadata ? metadata.description : "",
            image_url: metadata ? metadata.image : "",
            external_url: metadata ? metadata.external_url : "",
            attributes: metadata ? JSON.stringify(metadata.attributes) : "",
          });
        }

        let order = await orderServiceInstance.checkValidOrder({
          tokenId: req.query.token_id,
          categoriesId: categoryDetail.categories_id,
        });

        let owner;
        if (order.seller) {
          user = await userServiceInstance.getUser({ userId: order.seller });
          if (user) {
            owner = user.address;
          }
        }

        let tokenDetail = {
          contract: helper.toChecksumAddress(query.category_address),
          token_id: token.token_id,
          owner: owner,
          name: token.name,
          description: token.description,
          attributes: token.attributes,
          image_url: token.image_url,
          external_link: token.external_url,
          amount: tokenMetadata.amount,
          type: category.type,
          ...order,
        };

        if (tokenDetail) {
          return res.status(constants.RESPONSE_STATUS_CODES.OK).json({
            message: constants.RESPONSE_STATUS.SUCCESS,
            data: tokenDetail,
          });
        } else {
          return res
            .status(constants.RESPONSE_STATUS_CODES.BAD_REQUEST)
            .json({ message: constants.RESPONSE_STATUS.FAILURE });
        }
      }
    } catch (err) {
      console.log("new errror");
      console.log(err);
      return res
        .status(constants.RESPONSE_STATUS_CODES.INTERNAL_SERVER_ERROR)
        .json({ message: constants.MESSAGES.INTERNAL_SERVER_ERROR });
    }
  }
);

module.exports = router;
