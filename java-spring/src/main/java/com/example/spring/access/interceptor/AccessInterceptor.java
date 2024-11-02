package com.example.spring.access.interceptor;

import com.example.spring.access.entity.Access;
import com.example.spring.access.repository.AccessRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.sql.Timestamp;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class AccessInterceptor implements HandlerInterceptor {

    @Autowired
    private AccessRepository accessRepository;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws JsonProcessingException {
        Access access = new Access();
        access.setAccessedAt(new Timestamp(System.currentTimeMillis()));
        Map<String, List<String>> headersMap = Collections.list(request.getHeaderNames())
                .stream()
                .collect(Collectors.toMap(
                        Function.identity(),
                        h -> Collections.list(request.getHeaders(h))
                ));

        access.setHttpRequestHeaders(new ObjectMapper().writeValueAsString(headersMap));
        access.setUserInfo("{}");

        accessRepository.save(access);
        return true;
    }
}
