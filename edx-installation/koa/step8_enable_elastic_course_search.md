# Enable Elastic Course Search

1. Update LMS configure
$ vi /edx/etc/lms.yml
```
FEATURE:
	ENABLE_COURSE_DISCOVERY: True,
	ENABLE_COURSEWARE_SEARCH: True,
	ENABLE_DASHBOARD_SEARCH: True,
COURSE_DISCOVERY_FILTERS: ["org", "language", "modes"], #(overwriting default)
COURSE_DISCOVERY_MEANINGS: {
        "org": {
            "name": "Organization"
        },
        "modes": {
            "name": "Course Type",
            "terms": {
                "honor": "Honor",
                "verified": "Verified"
            }
        },
        "language": "en"
    },
SEARCH_ENGINE = "search.elastic.ElasticSearchEngine",
SEARCH_SKIP_ENROLLMENT_START_DATE_FILTERING: True, (if False, you have to set Enrollment Start Date for your course else the course'll be ignore.)
```

2. Update CMS configure
$ vi /edx/etc/studio.yml
```
FEATURE:
	ENABLE_COURSEWARE_INDEX = True
	ENABLE_LIBRARY_INDEX = True
	SEARCH_ENGINE = "search.elastic.ElasticSearchEngine"
```

3. Restart LMS & CMS
$ sudo /edx/bin/supervisorctl lms cms

4. Index for search
- You have to reindex your course on CMS. After reindexing, you will be able to see the courses on the /courses page and your dashboard page search will also start working.

# Referer
- https://discuss.openedx.org/t/got-0-results-found-when-using-course-search-in-lms-koa-native-instance-discovery-elasticsearch/4302/2
- https://edx.readthedocs.io/projects/edx-installing-configuring-and-running/en/open-release-koa.master/configuration/edx_search.html#install-edx-search
