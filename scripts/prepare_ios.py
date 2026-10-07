#!/usr/bin/env python3
import argparse
import json
import os
import re
import sys
from PIL import Image

def main():
    parser = argparse.ArgumentParser(description="Prepare iOS project for a specific congress app flavor.")
    parser.add_argument("--flavor", required=True, help="Flavor name (e.g. ama, somcep, agpc, amg11)")
    parser.add_argument("--bundle-id", required=True, help="iOS Bundle Identifier (e.g. ma.congress.ama)")
    parser.add_argument("--app-name", default=None, help="Display name for iOS app (e.g. AMA Events)")
    args = parser.parse_args()

    flavor = args.flavor.strip().lower()
    bundle_id = args.bundle_id.strip()
    app_name = (args.app_name or flavor.upper()).strip()

    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    pbxproj_path = os.path.join(base_dir, "ios", "Runner.xcodeproj", "project.pbxproj")
    plist_path = os.path.join(base_dir, "ios", "Runner", "Info.plist")
    iconset_dir = os.path.join(base_dir, "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset")

    print(f"=== Configuring iOS for Flavor: {flavor} ===")
    print(f"Bundle ID: {bundle_id}")
    print(f"App Name:  {app_name}")

    # 1. Update project.pbxproj
    if os.path.exists(pbxproj_path):
        with open(pbxproj_path, "r", encoding="utf-8") as f:
            pbx_content = f.read()

        def replace_bundle_id(match):
            val = match.group(1).strip()
            if "RunnerTests" in val:
                return f"PRODUCT_BUNDLE_IDENTIFIER = {bundle_id}.RunnerTests;"
            return f"PRODUCT_BUNDLE_IDENTIFIER = {bundle_id};"

        updated_pbx = re.sub(
            r"PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;\n]+);",
            replace_bundle_id,
            pbx_content
        )

        with open(pbxproj_path, "w", encoding="utf-8") as f:
            f.write(updated_pbx)
        print(f"✓ Updated Bundle Identifier in {pbxproj_path}")
    else:
        print(f"Warning: {pbxproj_path} not found!")

    # 2. Update Info.plist
    if os.path.exists(plist_path):
        with open(plist_path, "r", encoding="utf-8") as f:
            plist_content = f.read()

        # Update CFBundleDisplayName
        plist_content = re.sub(
            r"<key>CFBundleDisplayName</key>\s*<string>[^<]*</string>",
            f"<key>CFBundleDisplayName</key>\n\t<string>{app_name}</string>",
            plist_content
        )

        # Update CFBundleName
        plist_content = re.sub(
            r"<key>CFBundleName</key>\s*<string>[^<]*</string>",
            f"<key>CFBundleName</key>\n\t<string>{app_name}</string>",
            plist_content
        )

        # Update NSCalendarsUsageDescription
        cal_desc = f"{app_name} utilise le calendrier pour enregistrer les sessions sélectionnées."
        plist_content = re.sub(
            r"<key>NSCalendarsUsageDescription</key>\s*<string>[^<]*</string>",
            f"<key>NSCalendarsUsageDescription</key>\n\t<string>{cal_desc}</string>",
            plist_content
        )

        with open(plist_path, "w", encoding="utf-8") as f:
            f.write(plist_content)
        print(f"✓ Updated App Name and permissions in {plist_path}")
    else:
        print(f"Warning: {plist_path} not found!")

    # 3. Update iOS App Icons
    icon_candidates = [
        os.path.join(base_dir, "assets", "branding", f"{flavor}_app_icon.png"),
        os.path.join(base_dir, "assets", "branding", f"{flavor}.png"),
        os.path.join(base_dir, "playstore_assets", flavor, f"{flavor}_icon_512x512.png"),
    ]
    master_icon_path = next((p for p in icon_candidates if os.path.exists(p)), None)

    if master_icon_path and os.path.exists(iconset_dir):
        contents_json_path = os.path.join(iconset_dir, "Contents.json")
        if os.path.exists(contents_json_path):
            with open(contents_json_path, "r", encoding="utf-8") as f:
                contents = json.load(f)

            master_img = Image.open(master_icon_path).convert("RGBA")
            # Create a 1024x1024 white RGB canvas (Apple requires no alpha on App Store icon)
            canvas_1024 = Image.new("RGB", (1024, 1024), (255, 255, 255))
            if master_img.width == 1024 and master_img.height == 1024 and master_img.mode == "RGB":
                canvas_1024 = master_img
            else:
                ratio = min(960 / master_img.width, 960 / master_img.height)
                nw, nh = int(master_img.width * ratio), int(master_img.height * ratio)
                resized_master = master_img.resize((nw, nh), Image.Resampling.LANCZOS)
                canvas_1024.paste(resized_master, ((1024 - nw) // 2, (1024 - nh) // 2), resized_master)

            for img_info in contents.get("images", []):
                filename = img_info.get("filename")
                size_str = img_info.get("size", "0x0")
                scale_str = img_info.get("scale", "1x")
                if not filename:
                    continue

                w_pt, h_pt = [float(x) for x in size_str.split("x")]
                scale = float(scale_str.replace("x", ""))
                px_w, px_h = int(w_pt * scale), int(h_pt * scale)

                target_file = os.path.join(iconset_dir, filename)
                icon_resized = canvas_1024.resize((px_w, px_h), Image.Resampling.LANCZOS)
                icon_resized.save(target_file, "PNG")

            print(f"✓ Generated iOS app icons in {iconset_dir} from {os.path.basename(master_icon_path)}")
    else:
        print(f"Note: No master icon found for flavor {flavor}, retaining existing icons.")

    print("=== iOS Preparation Complete ===")

if __name__ == "__main__":
    main()
