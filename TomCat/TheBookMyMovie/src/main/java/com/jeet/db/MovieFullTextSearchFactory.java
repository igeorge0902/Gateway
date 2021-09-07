package com.jeet.db;

import org.apache.lucene.index.Term;
import org.apache.lucene.search.Filter;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.QueryWrapperFilter;
import org.apache.lucene.search.TermQuery;
import org.hibernate.search.annotations.Factory;

public class MovieFullTextSearchFactory {
	    private String category;

	    /**
	     * injected parameter
	     */
	    public void setCategory(String category) {
	        this.category = category;
	    }
		
	    @Factory
	    public Query getFilter() {	    	
	    	TermQuery termQuery = new TermQuery(new Term( "category", category));
			Filter termFilter = new QueryWrapperFilter( termQuery );
			return termFilter;

	    }
	
	
}
