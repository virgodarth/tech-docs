```
Traceback (most recent call last):
  File "/edx/app/edxapp/edx-platform/lms/djangoapps/courseware/views/views.py", line 609, in get
    return super(CourseTabView, self).get(request, course=course, page_context=page_context, **kwargs)
  File "/edx/app/edxapp/venvs/edxapp/lib/python3.5/site-packages/web_fragments/views.py", line 25, in get
    fragment = self.render_to_fragment(request, **kwargs)
  File "/edx/app/edxapp/edx-platform/lms/djangoapps/courseware/views/views.py", line 771, in render_to_fragment
    return tab.render_to_fragment(request, course, **kwargs)
  File "/edx/app/edxapp/edx-platform/common/lib/xmodule/xmodule/tabs.py", line 300, in render_to_fragment
    return self.fragment_view.render_to_fragment(request, course_id=six.text_type(course.id), **kwargs)
  File "/edx/app/edxapp/edx-platform/lms/djangoapps/discussion/views.py", line 723, in render_to_fragment
    base_context = _create_base_discussion_view_context(request, course_key)
  File "/edx/app/edxapp/edx-platform/lms/djangoapps/discussion/views.py", line 423, in _create_base_discussion_view_context
    user_info = cc_user.to_dict()
  File "/edx/app/edxapp/edx-platform/openedx/core/djangoapps/django_comment_common/comment_client/models.py", line 62, in to_dict
    self.retrieve()
  File "/edx/app/edxapp/edx-platform/openedx/core/djangoapps/django_comment_common/comment_client/models.py", line 67, in retrieve
    self._retrieve(*args, **kwargs)
  File "/edx/app/edxapp/edx-platform/openedx/core/djangoapps/django_comment_common/comment_client/user.py", line 159, in _retrieve
    metric_tags=self._metric_tags,
  File "/edx/app/edxapp/edx-platform/openedx/core/djangoapps/django_comment_common/comment_client/utils.py", line 99, in perform_request
    content=response.text[:100]
openedx.core.djangoapps.django_comment_common.comment_client.utils.CommentClientError: Invalid JSON response for request b393e144-f613-44cb-82d4-d0cb65abffc6; first 100 characters: '<html>
<head><title>502 Bad Gateway</title></head>
<body>
<center><h1>502 Bad Gateway</h1></cente'
Sep 17 00:24:11 ubuntu [service_variant=lms][django.request][env:sandbox] ERROR [ubuntu  119380] [user None] [log.py:228] - Internal Server Error: /courses/course-v1:AmazingEnglish+ATT001+2020/discussion/forum/
```

sudo su forum -s /bin/bash
cd ~/cs_comments_service
source ~/forum_env
rake search:initialize
