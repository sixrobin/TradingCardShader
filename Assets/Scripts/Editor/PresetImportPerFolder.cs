namespace RSLib.Editor
{
	using System.IO;
	using UnityEditor;
	using UnityEditor.Presets;

	/// <summary>
	/// Applies a preset based on the folder an asset is imported in.
	/// This script chooses the Preset that is in the same folder as the asset.
	/// If there is no Preset in the folder, this script searches parent folders.
	/// If there are no Presets in parent folders, Unity uses the default Preset that the Preset window specifies.
	/// Code from Unity Technologies (https://docs.unity.cn/2019.1/Documentation/Manual/DefaultPresetsByFolder.html).
	/// </summary>
	public class PresetImportPerFolder : AssetPostprocessor
	{
		private void OnPreprocessAsset()
		{
			if (!assetImporter.importSettingsMissing)
                return;

            string path = Path.GetDirectoryName(assetPath);

			while (!string.IsNullOrEmpty(path))
			{
                string[] presetGuids = AssetDatabase.FindAssets("t:Preset", new[] { path });
				foreach (string presetGuid in presetGuids)
				{
					string presetPath = AssetDatabase.GUIDToAssetPath(presetGuid);
					if (Path.GetDirectoryName(presetPath) == path && AssetDatabase.LoadAssetAtPath<Preset>(presetPath).ApplyTo(this.assetImporter))
						return;
				}

				path = Path.GetDirectoryName(path);
			}
		}
	}
}