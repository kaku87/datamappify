class GroupRepositorySequel
  include Datamappify::Repository

  for_entity Group
  default_provider :Sequel
end
