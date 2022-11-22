DELETE FROM template_folder_map WHERE template_folder_id in (SELECT id FROM template_folder WHERE name LIKE '%test-grandchild%');
DELETE FROM template_folder_map WHERE template_folder_id in (SELECT id FROM template_folder WHERE name LIKE '%test-child%');
DELETE FROM template_folder_map WHERE template_folder_id in (SELECT id FROM template_folder WHERE name LIKE '%test-parent%');
DELETE FROM user_folder_permissions WHERE template_folder_id in (SELECT id FROM template_folder WHERE name LIKE '%test-grandchild%');
DELETE FROM user_folder_permissions WHERE template_folder_id in (SELECT id FROM template_folder WHERE name LIKE '%test-child%');
DELETE FROM user_folder_permissions WHERE template_folder_id in (SELECT id FROM template_folder WHERE name LIKE '%test-parent%');
DELETE FROM template_folder WHERE name LIKE '%test-grandchild%';
DELETE FROM template_folder WHERE name LIKE '%test-child%';
DELETE FROM template_folder WHERE name LIKE '%test-parent%';
