-- ============================================
-- Workspaces — Abyss
-- Keep 1-5 alive so the bar always has five buttons, even when empty.
-- ============================================

for i = 1, 5 do
    hl.workspace_rule({
        workspace = tostring(i),
        persistent = true,
    })
end
