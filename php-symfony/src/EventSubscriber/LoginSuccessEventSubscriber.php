<?php

namespace App\EventSubscriber;

use App\Entity\Access;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\Security\Core\User\OidcUser;
use Symfony\Component\Security\Http\Event\LoginSuccessEvent;

readonly class LoginSuccessEventSubscriber implements EventSubscriberInterface
{
    public function __construct(
        private LoggerInterface $logger,
        private EntityManagerInterface $entityManager,
    ) {
    }

    public function onLoginSuccessEvent(LoginSuccessEvent $event): void
    {
        $this->logger->info($event->getRequest());
        /** @var OidcUser $user */
        $user = $event->getUser();

        $access = new Access();
        $access->setAccessedAt(new \DateTimeImmutable());
        $access->setHttpRequestHeaders($event->getRequest()->headers->all());
        $access->setUserInfo(
            [
                'sub' => $user->getSub(),
                'email' => $user->getEmail(),
                'given_name' => $user->getGivenName(),
                'family_name' => $user->getFamilyName(),
                'name' => $user->getName(),
                'preferred_username' => $user->getPreferredUsername(),
            ]
        );

        $this->entityManager->persist($access);
        $this->entityManager->flush();
    }

    public static function getSubscribedEvents(): array
    {
        return [
            LoginSuccessEvent::class => 'onLoginSuccessEvent',
        ];
    }
}
