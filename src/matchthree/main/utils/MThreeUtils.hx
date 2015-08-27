package matchthree.main.utils;
import flambe.asset.AssetPack;
import flambe.display.Texture;
import matchthree.main.element.tile.TileDataType;
import matchthree.name.AssetName;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeUtils
{
	public static function GetTileTexture(type: TileDataType, gameAsset: AssetPack): Texture {
		if (type == TileDataType.TILE_TRIANGLE) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_1);
		}
		else if (type == TileDataType.TILE_HEXAGON) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_2);
		}
		else if (type == TileDataType.TILE_SQAURE) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_3);
		}
		else if (type == TileDataType.TILE_HEPTAGON) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_4);
		}
		else if (type == TileDataType.TILE_DIAMOND) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_5);
		}
		else if (type == TileDataType.TILE_CIRCLE) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_6);
		}
		
		return null;
	}
}