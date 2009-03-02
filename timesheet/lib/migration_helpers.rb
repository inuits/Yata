module MigrationHelpers
  def foreign_key(from_table, from_column, to_table)
    constraint_name = "fk_#{from_table}_#{from_column}" 

    execute %{alter table #{from_table}
              add constraint #{constraint_name}
              foreign key (#{from_column})
              references #{to_table}(id)}
  end
  def foreign_key_cascade(from_table, from_column, to_table)
    constraint_name = "fk_#{from_table}_#{from_column}" 

    execute %{alter table #{from_table}
              add constraint #{constraint_name}
              foreign key (#{from_column})
              references #{to_table}(id)
              on delete cascade}
  end
  def drop_foreign_key(from_table, from_column)
    constraint_name = "fk_#{from_table}_#{from_column}" 

    execute %{alter table #{from_table}
              drop foreign key #{constraint_name}}
  end
end
