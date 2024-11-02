package com.example.spring.access.entity;

import com.vladmihalcea.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import org.hibernate.annotations.Type;

import java.sql.Timestamp;

@Entity
public class Access {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "accessed_at")
    private Timestamp accessedAt;

    @Type(JsonType.class)
    @Column(name = "user_info", columnDefinition = "json")
    private String userInfo;

    @Type(JsonType.class)
    @Column(name = "http_request_headers", columnDefinition = "json")
    private String httpRequestHeaders;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public Timestamp getAccessedAt() {
        return accessedAt;
    }

    public void setAccessedAt(Timestamp accessedAt) {
        this.accessedAt = accessedAt;
    }

    public String getUserInfo() {
        return userInfo;
    }

    public void setUserInfo(String userInfo) {
        this.userInfo = userInfo;
    }

    public String getHttpRequestHeaders() {
        return httpRequestHeaders;
    }

    public void setHttpRequestHeaders(String httpRequestHeaders) {
        this.httpRequestHeaders = httpRequestHeaders;
    }
}
