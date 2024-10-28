<?php

namespace App\Entity;

use App\Repository\AccessRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: AccessRepository::class)]
class Access
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column]
    private ?\DateTimeImmutable $accessedAt = null;

    #[ORM\Column(nullable: true)]
    private ?array $userInfo = null;

    #[ORM\Column(type: Types::ARRAY, nullable: true)]
    private ?array $httpRequestHeaders = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getAccessedAt(): ?\DateTimeImmutable
    {
        return $this->accessedAt;
    }

    public function setAccessedAt(\DateTimeImmutable $accessedAt): static
    {
        $this->accessedAt = $accessedAt;

        return $this;
    }

    public function getUserInfo(): ?array
    {
        return $this->userInfo;
    }

    public function setUserInfo(?array $userInfo): static
    {
        $this->userInfo = $userInfo;

        return $this;
    }

    public function getHttpRequestHeaders(): ?array
    {
        return $this->httpRequestHeaders;
    }

    public function setHttpRequestHeaders(?array $httpRequestHeaders): static
    {
        $this->httpRequestHeaders = $httpRequestHeaders;

        return $this;
    }
}
