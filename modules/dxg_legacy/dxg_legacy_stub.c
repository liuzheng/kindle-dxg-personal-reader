// SPDX-License-Identifier: GPL-2.0-only
/*
 * Build-only external-module scaffold.
 *
 * This module deliberately binds to no DXG hardware. Replace it only after
 * documenting source provenance, licensing, API migration, and smoke tests.
 */

#include <linux/init.h>
#include <linux/module.h>

static int __init dxg_legacy_stub_init(void)
{
	pr_info("dxg_legacy_stub: build scaffold loaded\n");
	return 0;
}

static void __exit dxg_legacy_stub_exit(void)
{
	pr_info("dxg_legacy_stub: build scaffold unloaded\n");
}

module_init(dxg_legacy_stub_init);
module_exit(dxg_legacy_stub_exit);

MODULE_AUTHOR("Kindle DXG modernization project");
MODULE_DESCRIPTION("DXG legacy compatibility module scaffold");
MODULE_LICENSE("GPL");
