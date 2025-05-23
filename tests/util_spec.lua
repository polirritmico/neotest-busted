local util = require("neotest-busted.util")
local lib = require("neotest.lib")

describe("util", function()
    describe("trim_quotes", function()
        it("trims quotes", function()
            assert.are.same(util.trim_quotes('"this will be trimmed"'), "this will be trimmed")
            assert.are.same(
                util.trim_quotes("\"'[[this will be trimmed]]'\""),
                "'[[this will be trimmed]]'"
            )
            assert.are.same(
                util.trim_quotes('"[brackets will not be trimmed]"'),
                "[brackets will not be trimmed]"
            )
            assert.are.same(
                util.trim_quotes("this will not be trimmed"),
                "this will not be trimmed"
            )
        end)
    end)

    describe("create_path", function()
        it("creates paths using os-specific path separator", function()
            assert.are.same(util.create_path("some", "path"), "some" .. lib.files.sep .. "path")
        end)
    end)

    describe("glob", function()
        it("globs", function()
            local path = util.create_path("lua", "**", "*.lua")

            assert.are.same(util.glob(path), {
                "lua/neotest-busted/async.lua",
                "lua/neotest-busted/busted-cli-runner.lua",
                "lua/neotest-busted/busted-util.lua",
                "lua/neotest-busted/cache.lua",
                "lua/neotest-busted/compat.lua",
                "lua/neotest-busted/config.lua",
                "lua/neotest-busted/health.lua",
                "lua/neotest-busted/init.lua",
                "lua/neotest-busted/logging.lua",
                "lua/neotest-busted/output_handler.lua",
                "lua/neotest-busted/start_debug.lua",
                "lua/neotest-busted/types.lua",
                "lua/neotest-busted/util.lua",
            })
        end)
    end)

    describe("create_package_path_argument", function()
        it("creates package path argument", function()
            local args = { "some/path", "some/other/path" }

            assert.are.same(util.create_package_path_argument("package.path", args), {
                "-c",
                "lua package.path = 'some/path;some/other/path;' .. package.path",
            })
        end)

        it("handles nil or empty array", function()
            ---@diagnostic disable-next-line: param-type-mismatch
            assert.are.same(util.create_package_path_argument("package.path", nil), {})
            assert.are.same(util.create_package_path_argument("package.path", {}), {})
        end)
    end)

    describe("split_position_id", function()
        it("splits position id", function()
            local parts = util.split_position_id('some/path::"describe"::"test"')

            assert.are.same(parts, {
                "some/path",
                '"describe"',
                '"test"',
            })
        end)
    end)

    describe("strip_position_id", function()
        local position_id = 'some/path::"describe"::"test"'

        it("strips position id with default concat", function()
            local path, parts = util.strip_position_id(position_id)

            assert.are.same(path, "some/path")
            assert.are.same(parts, "describe test")
        end)

        it("strips position id with custom concat", function()
            local path, parts = util.strip_position_id(position_id, "::")

            assert.are.same(path, "some/path")
            assert.are.same(parts, "describe::test")
        end)
    end)
end)
