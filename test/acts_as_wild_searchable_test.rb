require 'test_helper'

class ActsAsWildSearchableTest < ActiveSupport::TestCase
  test "modules exists" do
    assert_kind_of Module, ActsAsWildSearchable
  end
  
  test "query_single_no_clause_no_wild" do    
    query = User.name_like?("Herminio")
    assert query.explain.include?("name like '%Herminio%'")
    assert_kind_of ActiveRecord::Relation, query
  end
  
  test "query_multiple_no_clause_no_wild" do    
    query = User.name_like?("Herminio", "Kalli")
    assert query.explain.include?("name like '%Herminio%' or name like '%Kalli%'")
    assert_kind_of ActiveRecord::Relation, query
  end
  
  test "query_single_no_clause_wild_left" do    
    query = User.name_like?("Herminio", :left=>true)
    assert query.explain.include?("name like '%Herminio'")
    assert_kind_of ActiveRecord::Relation, query
  end

  test "query_single_no_clause_wild_right" do    
    query = User.name_like?("Herminio", :right=>true)
    assert query.explain.include?("name like 'Herminio%'")
    assert_kind_of ActiveRecord::Relation, query
  end
  
  test "query_or_left" do    
    query = User.name_like?("Herminio", "Kalli", :clause => "or", :left=>true)
    assert query.explain.include?("name like '%Herminio' or name like '%Kalli'")
    assert_kind_of ActiveRecord::Relation, query
  end 
  
  test "query_and_left" do
    query = User.name_like?("Herminio", "Kalli", :clause => "and", :left=>true)
    assert query.explain.include?("name like '%Herminio' and name like '%Kalli'")
    assert_kind_of ActiveRecord::Relation, query
  end
  
  test "query_or_right" do
    query = User.name_like?("Herminio", "Kalli", :clause => "or", :right=>true)
    assert query.explain.include?("name like 'Herminio%' or name like 'Kalli%'")
    assert_kind_of ActiveRecord::Relation, query
  end

  test "query_and_right" do
    query = User.name_like?("Herminio", "Kalli", :clause => "and", :right=>true)
    assert query.explain.include?("name like 'Herminio%' and name like 'Kalli%'")
    assert_kind_of ActiveRecord::Relation, query
  end

  
end
